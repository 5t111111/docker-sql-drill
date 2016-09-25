#! /usr/bin/env bash

echo "CREATE DATABASE sql_drill DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;" | mysql -uroot
echo "GRANT ALL PRIVILEGES ON sql_drill.* TO 'sql_drill'@'%' IDENTIFIED BY 'sql_drill'; FLUSH PRIVILEGES" | mysql -uroot
cat /create_for_mysql.sql | mysql -usql_drill -psql_drill sql_drill
cat /data.sql | mysql -usql_drill -psql_drill sql_drill
