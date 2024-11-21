#!/bin/sh
set -eux
inv=$(./localinvite.sh | jq -r .code)
./goat.sh account create --handle mod2.pds.gsky.ln4.net --password 123 --email mod2@example.net -invite-code "$inv"
./goat.sh account create --handle mod.pds.gsky.ln4.net --password 123 --email mod@example.net -invite-code "$inv"
./goat.sh account create --handle feedgen.pds.gsky.ln4.net --password 123 --email feedgen@example.net -invite-code "$inv"
./goat.sh account create --handle user5.pds.gsky.ln4.net --password 123 --email user5@example.net -invite-code "$inv"
./goat.sh account create --handle user4.pds.gsky.ln4.net --password 123 --email user4@example.net -invite-code "$inv"
./goat.sh account create --handle appview.pds.gsky.ln4.net --password 123 --email appview@example.net -invite-code "$inv"
./goat.sh account create --handle user1.pds.gsky.ln4.net --password 123 --email user1@example.net -invite-code "$inv"
./goat.sh account create --handle user2.pds.gsky.ln4.net --password 123 --email user2@example.net -invite-code "$inv"
./goat.sh account create --handle user3.pds.gsky.ln4.net --password 123 --email user3@example.net -invite-code "$inv"
