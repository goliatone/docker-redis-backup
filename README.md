## Docker Redis Backup
Docker image to back up a running Redis instance.

Rolling backups of a Redis instance using `cron` to a volume in `/backups` and a s3 bucket.

### Environment Variables

The script uses environment variables to take options:

- REDIS_PORT=6379
- REDIS_HOST=redis (name of your Redis service)
- CRON_SCHEDULE=0 2 * * * (Daily)
- CRON_CLEANUP=0 5 1 * * (Recurrent, first day the month)

Optionally, if you want to save the dump using S3, set the following variables:

- S3_BUCKET
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY

### Manually triggering a backup

Using docker:

```
docker run -ti \
  -e AWS_SECRET_ACCESS_KEY='<AWS_SECRET_ACCESS_KEY>' \
  -e AWS_ACCESS_KEY_ID='<AWS_ACCESS_KEY_ID>' \
  -e S3_BUCKET=<S3_BUCKET> \
  -e REDIS_HOST=<REDIS_HOST> \
  -e REDIS_PORT=<REDIS_PORT> \
  -e CRON_SCHEDULE="* * * * *" \
  -v $(pwd)/logs:/var/log \
  -v $(pwd)/redisbackup:/backups \
  --name redis-backup \
  goliatone/docker-redis-backup
```

You can also specify the contents of the dump:

```
-v /var/lib/redis/6379/dump.rdb:/dump.rdb
```

If you have built your container, then you can trigger a backup manually:
```
docker exec -ti <CONTAINER_NAME|CONTAINER_ID> backup.sh
```

```
$ docker exec -ti redis-backup backup.sh
```


#### Development

Build and publish:

```
docker build -t goliatone/docker-redis-backup .
```

```
docker push goliatone/docker-redis-backup
```

If you need to start a shell session into a non running container:

```
docker run -ti --entrypoint /bin/bash goliatone/docker-redis-backup
```
