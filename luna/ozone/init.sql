CREATE DATABASE gsky_ozone;
CREATE USER ozone WITH PASSWORD '3cdcf2b5df49d';
GRANT ALL PRIVILEGES ON DATABASE gsky_ozone TO ozone;

-- these are needed for newer versions of postgres
\c gsky_ozone postgres
GRANT ALL ON SCHEMA public TO ozone;
