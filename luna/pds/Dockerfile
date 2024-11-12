FROM ghcr.io/bluesky-social/pds:0.4.67
RUN echo 1
RUN apk --no-cache add ca-certificates
COPY ../rootCA.pem /usr/local/share/ca-certificates
COPY ../rootCA.pem /etc/ssl/certs
RUN sed -i "s/ip.range() === 'unicast'/true/" /app/node_modules/.pnpm/@atproto-labs+fetch-node@0.1.3/node_modules/@atproto-labs/fetch-node/src/util.ts
RUN sed -i "s/ip.range() !== 'unicast'/false/" /app/node_modules/.pnpm/@atproto-labs+fetch-node@0.1.3/node_modules/@atproto-labs/fetch-node/src/unicast.ts
RUN sed -i "s/ip.range() === 'unicast'/true/" /app/node_modules/.pnpm/@atproto-labs+fetch-node@0.1.3/node_modules/@atproto-labs/fetch-node/dist/util.js
RUN sed -i "s/ip.range() !== 'unicast'/false/" /app/node_modules/.pnpm/@atproto-labs+fetch-node@0.1.3/node_modules/@atproto-labs/fetch-node/dist/unicast.js
RUN update-ca-certificates -f
