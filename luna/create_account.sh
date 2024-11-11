#!/bin/sh
set -eux
inv=$(./localinvite.sh | jq .code)
./goat.sh account create --handle user1.pds.gsky.ln4.net --password 123 --email user1@example.net -invite-code "$inv"
./goat.sh account create --handle user2.pds.gsky.ln4.net --password 123 --email user2@example.net -invite-code "$inv"
./goat.sh account create --handle user3.pds.gsky.ln4.net --password 123 --email user3@example.net -invite-code "$inv"

