#!/bin/sh
set -eux
export JETSTREAM_WS_URL=wss://relay.gsky.ln4.net/xrpc/com.atproto.sync.subscribeRepos

cd ~/other.git/jetstream && ./jetstream
