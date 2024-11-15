#!/bin/bash
set -e

TIMESTAMP=`date +%d%m%Y-%H%M%S`
BACKUP_DIR=$HOME/backup-db/postgres

backup_database() {
  echo "### STARTING BACKUP THE TEST DATABASE ..."
  docker exec -i newfwd-db-test pg_dump -U us_fwd_dev us_fwd_test > $BACKUP_DIR/us_fwd_test_$TIMESTAMP.sql
  echo "### FINISHED BACKUP THE TEST DATABASE !!!"
}

remove_old_database() {
  echo "### CHECKING AND REMOVING THE TEST DATABASE FILE OLDER THAN 30 DAYS ..."
  find $BACKUP_DIR/ -type f -name "*.sql" -mtime +30 -exec rm -rf {} \;
}

case "$1" in
    backup)
        backup_database
    ;;
    cleanup)
        remove_old_database
    ;;
    *)
        echo "ERROR: WRONG SYNTAX, USING: ./backup-db.sh [backup | cleanup]"
        exit 1
    ;;
    "")
        echo "ERROR: WRONG SYNTAX, USING: ./backup-db.sh [backup | cleanup]"
        exit 1
    ;;
esac
