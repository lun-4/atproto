#!/bin/sh
set -eux
export ATP_PDS_HOST=https://pds.gsky.ln4.net
export ATP_PLC_HOST=https://plc.gsky.ln4.net
first_param=${1:-""}
if [ "$first_param" = "plc" ]; then
  shift
  ~/other.git/indigo/goat plc -plc-directory https://plc.gsky.ln4.net $*
else
  ~/other.git/indigo/goat $*
fi