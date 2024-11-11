FROM ghcr.io/bluesky-social/pds:0.4.67
RUN echo 1
RUN apk --no-cache add ca-certificates
COPY ../rootCA.pem /usr/local/share/ca-certificates
COPY ../rootCA.pem /etc/ssl/certs
RUN update-ca-certificates -f
