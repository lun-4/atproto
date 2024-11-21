#!/bin/sh
set -eux
export JETSTREAM_WS_URL=wss://relay.gsky.ln4.net/xrpc/com.atproto.sync.subscribeRepos
export JETSTREAM_LIVENESS_TTL=9000000000s

cd ~/other.git/jetstream && ./jetstream
