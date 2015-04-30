#!/bin/bash


date=$(date +%F-%H%M%S)
backup_location=~/backups
previous_day=`date -d yesterday +%F`


mkdir -p $backup_location
export PGPASSWORD='5346488k'

#echo "Cleaning up csv files 1 day older in $tmp"
#find /tmp -type f -name "*.csv" -mtime +1 -exec rm {} \;
#find $HOME/logs -type f -name "*.csv" -mtime +1 -exec rm {} \;

echo 'Cleaning backup files older than 30 days'
find $backup_location -type f -name "*.sql.gz" -mtime +30 -exec rm {} \;

echo 'Backing up gamedata database'
pg_dump gamedata -h localhost -U colson | gzip > $backup_location/gamedata_backup.$date.sql.gz

unset PGPASSWORD

rm -f $RUN_FILE_NAME
