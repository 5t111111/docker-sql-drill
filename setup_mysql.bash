#!/usr/bin/env bash

run_redash="docker-compose run --rm redash"

$run_redash /opt/redash/current/manage.py database create_tables


