#!/bin/bash

CRON_SCHEDULE=${CRON_SCHEDULE:-0 2 * * *}
CRON_CLEANUP=${CRON_CLEANUP:-0 5 1 * *}

CRON_ENVIRONMENT="
REDIS_HOST=${REDIS_HOST:-redis};
REDIS_PORT=${REDIS_PORT:-6379};
S3_BUCKET=${S3_BUCKET};
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID};
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY};
"

CRON_COMMAND="/backup.sh >> /var/log/backup_script.log 2>&1"

echo "VERSION: 0.0.1"
echo "Start backup script..."
echo
echo "CRON_SCHEDULE"
echo "$CRON_SCHEDULE"
echo
echo "CRON_ENVIRONMENT"
echo "$CRON_ENVIRONMENT"

touch tmpcron
echo "$CRON_ENVIRONMENT$CRON_SCHEDULE $CRON_COMMAND" >> tmpcron
echo "$CRON_CLEANUP /remove.sh" >> tmpcron
crontab tmpcron

cron start -f
# tail -f /var/log/backup_script.log
