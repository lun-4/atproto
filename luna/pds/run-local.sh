#!/bin/sh
set -eux
#cd ~/other.git/atproto/services/bsky && docker build -t bskyappview -f Dockerfile .
#docker run --network host -e LOG_ENABLED=true -e BSKY_PORT=9976 -e NODE_ENV=development -e PUBLIC_URL=http://localhost:9976 -e BSKY_DID_PLC_URL=https://plc.directory -e BSKY_BSYNC_URL=http://localhost:39999 -e BSKY_BLOB_RATE_LIMIT_BYPASS_KEY=asdf.com -e BSKY_BLOB_RATE_LIMIT_BYPASS_HOSTNAME=asdf.com -e MOD_SERVICE_DID=did:plc:ar7c4by46qjdydhdevvrndac -e BSKY_DATAPLANE_URLS=http://localhost:9931 -e BSKY_INDEXED_AT_EPOCH=2024-11-09T00:00:00Z -e BSKY_SERVICE_SIGNING_KEY=cdfeb707e884deb9b8d462911c31efdd029a07c5e39f5793838f13109a88509e --rm -it bsky-social-app:bskyappview

export PDS_DATA_DIRECTORY=$(realpath ./pds_data)
export PDS_BLOBSTORE_DISK_LOCATION=$(realpath ./pds_data_blobs)
export PDS_HOSTNAME="pds.gsky.ln4.net"
export PDS_PORT="2583"
export PDS_BLOB_UPLOAD_LIMIT="100000000000"
export PDS_DID_PLC_URL="https://plc.gsky.ln4.net"
export PDS_BSKY_APP_VIEW_URL="https://appview.gsky.ln4.net"
export PDS_BSKY_APP_VIEW_DID="did:plc:q36j6tnvaw6i5zutg6nb547c"
export PDS_REPORT_SERVICE_URL="https://ozone.gsky.ln4.net" # ozone?
export PDS_REPORT_SERVICE_DID="did:plc:BBBBBBBBBBBBBBBBBb"
export PDS_CRAWLERS="https://relay.gsky.ln4.net" # relay?
export LOG_ENABLED="true"
export PDS_JWT_SECRET="4abb6f48bbd656205134f0b78eab35aa"
export PDS_ADMIN_PASSWORD="2f28e4183b8ab1b5a684df9078483d74"
export PDS_PLC_ROTATION_KEY_K256_PRIVATE_KEY_HEX="754ce7ddd8d1baf21613b508ad89fababf581f945ca59b8d7e7393ed948c8b8d"
export NODE_OPTIONS=--use-openssl-ca

cd ~/other.git/atproto/services/pds && node --enable-source-maps index.js
