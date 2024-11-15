#!/bin/bash
set -e

TIMESTAMP=`date +%d%m%Y-%H%M%S`
BACKUP_DIR=$HOME/backup-db/maria-db

backup_database() {
  echo "### STARTING BACKUP THE MARIADB TEST DATABASE ..."
  docker exec -i mariadb-test mariadb --user=us_fwd_dev --password=Cyber2021 --database=us_fwd_test > $BACKUP_DIR/us_fwd_test_$TIMESTAMP.sql
  echo "### FINISHED BACKUP THE MARIADB TEST DATABASE !!!"
}

remove_old_database() {
  echo "### CHECKING AND REMOVING THE MARIADB TEST DATABASE FILE OLDER THAN 30 DAYS ..."
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
