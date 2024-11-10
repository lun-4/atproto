CREATE DATABASE bgs;
CREATE DATABASE carstore;

CREATE USER bigsky WITH PASSWORD 'caee4264961b47c';
GRANT ALL PRIVILEGES ON DATABASE bgs TO bigsky;
GRANT ALL PRIVILEGES ON DATABASE carstore TO bigsky;

-- these are needed for newer versions of postgres
\c bgs postgres
GRANT ALL ON SCHEMA public TO bigsky;

\c carstore postgres
GRANT ALL ON SCHEMA public TO bigsky;
