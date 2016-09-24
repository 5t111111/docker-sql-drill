#!/usr/bin/env bash

psql -U postgres -c "CREATE USER sql_drill WITH PASSWORD 'sql_drill';"
createdb -U postgres sql_drill --encoding=UTF8 --owner=sql_drill

psql -U sql_drill sql_drill < ./create_for_postgres.sql
psql -U sql_drill sql_drill < ./data.sql


