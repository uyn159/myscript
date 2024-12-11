#!/bin/bash

# Oracle RMAN backup script for 18.4 XE

# Set ORACLE_HOME and ORACLE_SID (adjust paths if needed)
export ORACLE_HOME=/u01/app/oracle/product/18.0.0/dbhomeXE
export ORACLE_SID=XE

# Set backup directory
BACKUP_DIR=/u01/app/oracle/backup

# Set log file
LOG_FILE=$BACKUP_DIR/rman_backup.log

# Connect to RMAN (XE uses a simplified connection)
rman target / >> $LOG_FILE 2>&1 << EOF

# Configure backup settings
CONFIGURE CHANNEL DEVICE TYPE DISK FORMAT '$BACKUP_DIR/%U';
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 7 DAYS;
CONFIGURE DEVICE TYPE DISK BACKUP TYPE TO COMPRESSED BACKUPSET;

# Perform full backup
BACKUP DATABASE PLUS ARCHIVELOG;

# Back up archive logs
BACKUP ARCHIVELOG ALL DELETE INPUT;

# List backups
LIST BACKUP;

EXIT;
EOF

# Check for errors
if [[ $? -ne 0 ]]; then
  echo "RMAN backup failed. Check the log file: $LOG_FILE"
  exit 1
else
  echo "RMAN backup completed successfully. Log file: $LOG_FILE"
fi
