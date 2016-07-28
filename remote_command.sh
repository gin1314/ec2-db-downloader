#!/bin/bash

cd ~
mysqldump -u root -pPASSWORD -h DB_IP db_name > /tmp/dump.sql
tar czf /tmp/dump.sql.tar.gz /tmp/dump.sql
ls -la | grep dump