#!/bin/bash

CRON_SCHEDULE=${CRON_SCHEDULE:-0 2 * * *}
CRON_CLEANUP=${CRON_CLEANUP:-0 5 1 * *}

CRON_ENVIRONMENT="
S3_BUCKET=${S3_BUCKET}
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
REDIS_HOST=${REDIS_HOST:-redis}
REDIS_PORT=${REDIS_PORT:-6379}
"

CRON_COMMAND="root /backup.sh >> /var/log/backup_script.log 2>&1"

echo "VERSION: 0.0.3"
echo "Start backup script..."
echo
echo "CRON_SCHEDULE"
echo " $CRON_SCHEDULE"
echo
echo "CRON_ENVIRONMENT"
echo "$CRON_ENVIRONMENT"

touch tmpcron
echo "# placed in /etc/cron.d by cronstart.sh" >> tmpcron
echo "$CRON_ENVIRONMENT$CRON_SCHEDULE $CRON_COMMAND" >> tmpcron
echo "$CRON_CLEANUP root /remove.sh >> /var/log/backup_script.log 2>&1" >> tmpcron
cat tmpcron > /etc/cron.d/backup-job
# crontab tmpcron

echo "tmpcron copied over /etc/cron.d/backup-job"
cat /etc/cron.d/backup-job

cron -f -L 15
# cron start -f
# tail -f /var/log/backup_script.log
