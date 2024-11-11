#!/bin/sh
set -eux
RELAY_ADMIN_KEY=868d92e4318475

curl -k 'https://relay.gsky.ln4.net/admin/subs/setPerDayLimit?limit=10000' \
  -H 'content-type: application-json' \
  -H "authorization: Bearer $RELAY_ADMIN_KEY" \
  -X POST


