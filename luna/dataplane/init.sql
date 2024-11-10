CREATE DATABASE bsky_dataplane;
CREATE USER dataplane_bsky WITH PASSWORD '35fe8e78fc60435';
GRANT ALL PRIVILEGES ON DATABASE bsky_dataplane TO dataplane_bsky;

-- these are needed for newer versions of postgres
\c bsky_dataplane postgres
GRANT ALL ON SCHEMA public TO dataplane_bsky;
