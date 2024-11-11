#!/bin/sh
mkdir -p gsky.ln4.net
mkcert -cert-file ./gsky.ln4.net/cert.pem -key-file ./gsky.ln4.net/key.pem gsky.ln4.net '*.gsky.ln4.net' '*.pds.gsky.ln4.net'
