#!/bin/sh
set -x
#cd ~/other.git/indigo && make build-relay-ui build
docker-compose up -d
sleep 1
cat init.sql | docker-compose exec -T relay_db psql -U postgres

mkdir ./data_bigsky
mkdir ./data_bigsky_events

export ENVIRONMENT=production
export DATABASE_URL="postgres://bigsky:caee4264961b47c@localhost:5857/bgs"
export CARSTORE_DATABASE_URL="postgres://bigsky:caee4264961b47c@localhost:5857/carstore"
export DATA_DIR=./data_bigsky
export RELAY_PERSISTER_DIR=./data_bigsky_events
export GOLOG_LOG_LEVEL=info
export RESOLVE_ADDRESS="1.1.1.1:53"
export FORCE_DNS_UDP=true
export RELAY_COMPACT_INTERVAL=0
export RELAY_DEFAULT_REPO_LIMIT=500000
export MAX_CARSTORE_CONNECTIONS=12
export MAX_METADB_CONNECTIONS=12
export MAX_FETCH_CONCURRENCY=25
export RELAY_CONCURRENCY_PER_PDS=20
export RELAY_MAX_QUEUE_PER_PDS=200
export RELAY_ADMIN_KEY=868d92e4318475

~/other.git/indigo/bigsky --api-listen 127.0.0.1:2470
