FROM ghcr.io/bluesky-social/pds:0.4.67
RUN apk --no-cache add ca-certificates
COPY ../rootCA.pem /usr/local/share/ca-certificates
RUN update-ca-certificates
