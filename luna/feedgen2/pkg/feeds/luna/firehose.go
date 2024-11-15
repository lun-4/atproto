package luna

import (
	"bytes"
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"log/slog"
	"net/http"
	"os"
	"time"

	"github.com/bluesky-social/indigo/api/atproto"
	appbsky "github.com/bluesky-social/indigo/api/bsky"
	"github.com/bluesky-social/indigo/atproto/data"
	"github.com/bluesky-social/indigo/events"
	"github.com/bluesky-social/indigo/events/schedulers/sequential"
	"github.com/bluesky-social/indigo/repo"
	"github.com/ericvolp12/go-bsky-feed-generator/pkg/feedrouter"
	"github.com/gorilla/websocket"

	_ "github.com/mattn/go-sqlite3"
)

type DynamicFeed interface {
	feedrouter.Feed
	Spawn(context.Context)
	GetFeedName() string
}

func ConfigureLunaFeeds(ctx context.Context) ([]DynamicFeed, error) {
	relayAddress := os.Getenv("RELAY_WEBSOCKET_ADDRESS")
	if relayAddress == "" {
		panic("relay address required")
	}
	feeds := make([]DynamicFeed, 0)
	feeds = append(feeds, &FollowingFeed{
		FeedActorDID: os.Getenv("FOLLOWING_FEED_ACTOR_DID"),
		FeedName:     os.Getenv("FOLLOWING_FEED_NAME"),
		relayAddress: relayAddress,
	})
	return feeds, nil
}

type FollowingFeed struct {
	FeedActorDID string
	FeedName     string
	db           *sql.DB
	relayAddress string
}

func (ff *FollowingFeed) Describe(ctx context.Context) ([]appbsky.FeedDescribeFeedGenerator_Feed, error) {
	return []appbsky.FeedDescribeFeedGenerator_Feed{
		{
			Uri: "at://" + ff.FeedActorDID + "/app.bsky.feed.generator/" + ff.FeedName,
		},
	}, nil
}

func (ff *FollowingFeed) GetFeedName() string {
	return ff.FeedName
}

func (ff *FollowingFeed) GetPage(ctx context.Context, feed string, userDID string, limit int64, cursor string) ([]*appbsky.FeedDefs_SkeletonFeedPost, *string, error) {
	return nil, nil, nil
}

func (ff *FollowingFeed) Spawn(ctx context.Context) {
	f, err := os.OpenFile("following_feed.log", os.O_RDWR|os.O_CREATE|os.O_APPEND, 0666)
	if err != nil {
		slog.Error("error opening log file", slog.Any("err", err))
		panic("failed to open log file")
	}
	defer f.Close()

	wrt := io.MultiWriter(os.Stderr, f)

	log.SetOutput(wrt)
	if os.Getenv("DEBUG") == "1" {
		slog.SetLogLoggerLevel(slog.LevelDebug)
	}

	db, err := sql.Open("sqlite3", "follower_feed_state.db")
	if err != nil {
		log.Fatal(err)
	}
	//	defer db.Close()

	// TODO rest of tables
	_, err = db.Exec(`
	PRAGMA journal_mode=WAL;
	PRAGMA busy_timeout = 5000;
	PRAGMA synchronous = NORMAL;
	PRAGMA cache_size = 1000000000;
	PRAGMA foreign_keys = true;
	PRAGMA temp_store = memory;

	CREATE TABLE IF NOT EXISTS follow_relationships (
		from_did text,
		to_did text,
		primary key (from_did, to_did)
	) STRICT;
	CREATE INDEX IF NOT EXISTS follow_relationships_from_did_index ON follow_relationships (from_did);

	CREATE TABLE IF NOT EXISTS posts (
		author_did text,
		at_path text,
		primary key (author_did, at_path)
	) STRICT;
	CREATE INDEX IF NOT EXISTS posts_author_did_index ON posts (author_did);

	CREATE TABLE IF NOT EXISTS firehose_sync_position (
		cursor int
	) STRICT;
	CREATE INDEX IF NOT EXISTS firehose_sync_position_cursor_index ON firehose_sync_position (cursor);
	`)
	if err != nil {
		panic(err)
	}
	ff.db = db
	go ff.main(ctx)
}

func (ff *FollowingFeed) main(ctx context.Context) {
	for {
		err := ff.firehoseConsumer(ctx)
		if err != nil {
			slog.Error("error in firehose consumer", slog.Any("err", err))
		}
		slog.Info("firehose consumer stopped, restarting in 3 seconds")
		time.Sleep(3 * time.Second)
	}
}

func (ff *FollowingFeed) firehoseConsumer(ctx context.Context) error {
	uri := fmt.Sprintf("%s/xrpc/com.atproto.sync.subscribeRepos?cursor=0", ff.relayAddress)
	con, _, err := websocket.DefaultDialer.Dial(uri, http.Header{})
	if err != nil {
		return err
	}
	rsc := &events.RepoStreamCallbacks{
		RepoCommit: func(evt *atproto.SyncSubscribeRepos_Commit) error {
			rr, err := repo.ReadRepoFromCar(ctx, bytes.NewReader(evt.Blocks))
			if err != nil {
				return nil
			}
			userDid := evt.Repo
			for _, op := range evt.Ops {
				slog.Debug("incoming event", slog.String("path", op.Path), slog.Any("cid", op.Cid), slog.String("action", op.Action), slog.String("repo", evt.Repo))
				rcid, recBytes, err := rr.GetRecordBytes(ctx, op.Path)
				if err != nil {
					return nil
				}
				slog.Debug("event", slog.String("rcid", rcid.String()))

				recordType, recordData, err := data.ExtractTypeCBORReader(bytes.NewReader(*recBytes))
				if err != nil {
					return nil
				}
				slog.Debug("record", slog.String("record", recordType))

				switch recordType {
				case "app.bsky.graph.follow":
					rec, err := data.UnmarshalCBOR(recordData)
					if err != nil {
						return nil
					}

					recJSON, err := json.Marshal(rec)
					if err != nil {
						return nil
					}

					subject, ok := rec["subject"].(string)
					slog.Debug("follow", slog.String("text", string(recJSON)))
					if ok {
						_, err := ff.db.Exec(`INSERT INTO follow_relationships (from_did, to_did) VALUES ($1, $2) ON CONFLICT DO NOTHING`, userDid, subject)
						if err != nil {
							slog.Error("error inserting following", slog.Any("err", err))
						} else {
							slog.Debug("followed", slog.String("from", userDid), slog.String("to", subject))
						}
					}
				case "app.bsky.feed.post":
					atPath := fmt.Sprintf("at://%s/%s", userDid, op.Path)
					_, err := ff.db.Exec(`INSERT INTO posts (author_did, at_path) VALUES ($1, $2) ON CONFLICT DO NOTHING`, userDid, atPath)
					if err != nil {
						slog.Error("error inserting post", slog.Any("err", err))
					} else {
						slog.Debug("post created", slog.String("at", atPath))
					}
				}
			}

			return nil
		},
	}

	sched := sequential.NewScheduler("following_feed", rsc.EventHandler)
	return events.HandleRepoStream(context.Background(), con, sched)
}
