#! /usr/bin/env bash

run_mysql="docker-compose run --rm mysql"

$run_mysql echo "CREATE DATABASE sql_drill DEFAULT CHARSET utf8;" | mysql -uroot
$run_mysql echo "GRANT ALL PRIVILEGES ON sql_drill.* TO 'sql_drill'@'%' IDENTIFIED BY 'sql_drill'; FLUSH PRIVILEGES" | mysql -uroot

$run_mysql cat /create_for_mysql.sql | mysql -usql_drill -psql_drill sql_drill
$run_mysql cat /data.sql | mysql -usql_drill -psql_drill sql_drill


