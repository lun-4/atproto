#!/bin/sh
set -x
docker-compose up -d
sleep 1
cat init.sql | docker-compose exec -T dataplane_db psql -U postgres

export POSTGRES_URL="postgres://dataplane_bsky:35fe8e78fc60435@localhost:5858/bsky_dataplane?schema=public"
export POSTGRES_SCHEMA=public
export POSTGRES_POOL_SIZE=10
export DID_PLC_URL=https://plc.gsky.ln4.net
export NODE_ENV=development
export LOG_ENABLED=true
export LOG_LEVEL=info

pnpm run start
