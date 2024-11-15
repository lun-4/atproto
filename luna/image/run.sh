#!/bin/sh
set -x

export PORT=9036
export NODE_ENV=development
export LOG_ENABLED=true
export LOG_LEVEL=info
export NODE_OPTIONS=--use-openssl-ca
export APPVIEW_URL=https://appview.gsky.ln4.net

pnpm run start
