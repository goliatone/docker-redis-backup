FROM        redis:3.2.1
MAINTAINER	goliatone <hello@goliatone.com>
LABEL		version="0.0.1"

RUN echo "deb http://httpredir.debian.org/debian wheezy-backports main" >> /etc/apt/sources.list

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update && \
    apt-get install -yqq python-pip cron && \
    apt-get -yqq clean && \
    rm -rf /var/lib/apt/lists/*

COPY /scripts/*.sh /usr/local/sbin/

RUN chmod +x /usr/local/sbin/*.sh && \
    cd / && \
    mkdir /backups && \
    mkfifo /var/log/backup_script.log && \
    rm -rf /var/lib/apt/lists/* && \
    pip install awscli

VOLUME /data
VOLUME /backups

ENTRYPOINT ["cronstart.sh"]
