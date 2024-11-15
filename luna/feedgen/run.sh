#!/bin/sh

export FEEDGEN_HOSTNAME=feedgen.gsky.ln4.net
export FEEDGEN_PORT=9917
export FEEDGEN_SQLITE_LOCATION=./feedgen.sqlite
export FEEDGEN_SUBSCRIPTION_ENDPOINT=wss://relay.gsky.ln4.net
export FEEDGEN_PUBLISHER_DID=did:plc:feeeedgeeeen

pnpm run start
