#!/bin/sh
set -eux
cd ~/other.git/did-method-plc/packages/server/pg && docker-compose up -d db
cd ~/other.git/did-method-plc/packages/server && yarn run start
