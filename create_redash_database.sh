#!/bin/bash
# This script assumes you're using docker-compose, with at least two images: redash for the redash instance
# and postgres for the postgres instance.
#
# This script is not idempotent and should be run once.

run_redash="docker-compose run --rm redash"

$run_redash /opt/redash/current/manage.py database create_tables

# Create default admin user
$run_redash /opt/redash/current/manage.py users create --admin --password admin "Admin" "admin"

run_psql="docker-compose run --rm postgres psql -h postgres -p 5432 -U postgres"

# Create redash_reader user. We don't use a strong password, as the instance supposed to be accesible only from the redash host.
$run_psql -c "CREATE ROLE redash_reader WITH PASSWORD 'redash_reader' NOCREATEROLE NOCREATEDB NOSUPERUSER LOGIN"
$run_psql -c "GRANT select(id,name,type) ON data_sources TO redash_reader;"
$run_psql -c "GRANT select(id,name) ON users TO redash_reader;"
$run_psql -c "GRANT select ON events, queries, dashboards, widgets, visualizations, query_results TO redash_reader;"

$run_redash /opt/redash/current/manage.py ds new "re:dash metadata" --type "pg" --options "{\"user\": \"redash_reader\", \"password\": \"redash_reader\", \"host\": \"postgres\", \"dbname\": \"postgres\"}"
