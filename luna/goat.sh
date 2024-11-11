#!/bin/sh
set -eux
export ATP_PDS_HOST=https://pds.gsky.ln4.net
if [ "$1" = "plc" ]; then
  shift
  ~/other.git/indigo/goat plc -plc-directory https://plc.gsky.ln4.net $*
else
  ~/other.git/indigo/goat $*
fi
