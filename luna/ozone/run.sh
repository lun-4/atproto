#!/bin/sh
set -x
docker-compose up -d
cat init.sql | docker-compose exec -T dataplane_db psql -U postgres

export OZONE_DID_PLC_URL=https://plc.gsky.ln4.net
export OZONE_PORT=9037
export OZONE_PUBLIC_URL="ozone.gsky.ln4.net"
export OZONE_SERVICE_ACCOUNT_HANDLE="mod.pds.gsky.ln4.net"
export OZONE_SERVER_DID="did:plc:ov5fmr5vfvml76joz5roqs2l"
export OZONE_ADMIN_DIDS="did:plc:ov5fmr5vfvml76joz5roqs2l"
export OZONE_ADMIN_PASSWORD="3ec373673d3414"
export OZONE_SIGNING_KEY_HEX="02c5f6a47ca8870e5bbdb6b4c8a8c18f8b17423f357c652bd464c84ef91ef922"
export OZONE_DB_POSTGRES_URL="postgresql://ozone:3cdcf2b5df49d@localhost:35199/gsky_ozone"
export OZONE_DB_MIGRATE=1
export OZONE_APPVIEW_URL=https://pds.gsky.ln4.net
export OZONE_APPVIEW_DID=did:plc:q36j6tnvaw6i5zutg6nb547c
export LOG_ENABLED=1

cd ~/other.git/ozone && node ./service

# setup normally
# get email token for plc operation from pds database:
# to go account.sqlite, 'select * from email_token'
