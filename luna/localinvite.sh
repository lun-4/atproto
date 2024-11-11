set -eux
curl -k --request POST \
          --user "admin:2f28e4183b8ab1b5a684df9078483d74" \
          --header "Content-Type: application/json" \
          --data '{"useCount": 1}' \
          "https://pds.gsky.ln4.net/xrpc/com.atproto.server.createInviteCode"

