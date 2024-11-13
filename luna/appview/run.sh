#!/bin/sh
set -eux
#cd ~/other.git/atproto/services/bsky && docker build -t bskyappview -f Dockerfile .
#docker run --network host -e LOG_ENABLED=true -e BSKY_PORT=9976 -e NODE_ENV=development -e PUBLIC_URL=http://localhost:9976 -e BSKY_DID_PLC_URL=https://plc.directory -e BSKY_BSYNC_URL=http://localhost:39999 -e BSKY_BLOB_RATE_LIMIT_BYPASS_KEY=asdf.com -e BSKY_BLOB_RATE_LIMIT_BYPASS_HOSTNAME=asdf.com -e MOD_SERVICE_DID=did:plc:ar7c4by46qjdydhdevvrndac -e BSKY_DATAPLANE_URLS=http://localhost:9931 -e BSKY_INDEXED_AT_EPOCH=2024-11-09T00:00:00Z -e BSKY_SERVICE_SIGNING_KEY=cdfeb707e884deb9b8d462911c31efdd029a07c5e39f5793838f13109a88509e --rm -it bsky-social-app:bskyappview
export LOG_ENABLED=true 
export BSKY_PORT=2584
export NODE_ENV=development 
export PUBLIC_URL=https://appview.gsky.ln4.net
export BSKY_DID_PLC_URL=https://plc.gsky.ln4.net
# setup this did plc by first starting pds, then create account, then stop pds, add this did, restart it
export BSKY_SERVER_DID=did:plc:q36j6tnvaw6i5zutg6nb547c
export BSKY_BSYNC_URL=http://localhost:39999
export BSKY_BLOB_RATE_LIMIT_BYPASS_KEY=asdf.com 
export BSKY_BLOB_RATE_LIMIT_BYPASS_HOSTNAME=asdf.com 
export MOD_SERVICE_DID=did:plc:ar7c4by46qjdydhdevvrndac 
export BSKY_DATAPLANE_URLS=http://dataplane.gsky.ln4.net:9329
export BSKY_INDEXED_AT_EPOCH=2024-11-09T00:00:00Z 
export BSKY_SERVICE_SIGNING_KEY=cdfeb707e884deb9b8d462911c31efdd029a07c5e39f5793838f13109a88509e
export NODE_OPTIONS=--use-openssl-ca

cd ~/other.git/atproto/services/bsky && node --enable-source-maps api.js
