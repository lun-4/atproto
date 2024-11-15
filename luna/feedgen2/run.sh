#!/bin/sh

set -eux
export PORT=9032
export DEBUG=1
export FEED_ACTOR_DID=did:plc:DONTUSETHIS
# export FOLLOWING_FEED_ACTOR_DID=did:plc:FOLLOWERFEEDGENTODO
# get the did used from feedgen.pds.gsky.ln4.net from create account
export FOLLOWING_FEED_ACTOR_DID=did:plc:34vf24bcdida7qwbuzdypynu
export FEED_ACTOR_DID=did:plc:34vf24bcdida7qwbuzdypynu
export FOLLOWING_FEED_NAME=following
export SERVICE_ENDPOINT=https://feedgen.gsky.ln4.net
export RELAY_WEBSOCKET_ADDRESS=wss://relay.gsky.ln4.net

make build
./feedgen
