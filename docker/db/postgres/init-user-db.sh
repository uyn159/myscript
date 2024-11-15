#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER us_fwd_dev;
    GRANT ALL PRIVILEGES ON DATABASE us_fwd_test TO us_fwd_dev;
    ALTER USER us_fwd_dev PASSWORD 'Cyber2021';
EOSQL
