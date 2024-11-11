#!/bin/sh
set -eux
cd ~/other.git/did-method-plc/packages/server/pg && docker-compose up -d db
export DATABASE_URL="postgres://bsky:yksb@localhost:5466/plc_dev"
export DEBUG_MODE=1
export LOG_ENABLED="true"
export LOG_LEVEL=debug
export LOG_DESTINATION=1
cd ~/other.git/did-method-plc/packages/server && yarn run start
