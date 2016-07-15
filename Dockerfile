FROM        redis:3.2.1
MAINTAINER	goliatone <hello@goliatone.com>
LABEL		version="0.0.3"

# RUN echo "deb http://httpredir.debian.org/debian wheezy-backports main" >> /etc/apt/sources.list
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update && \
    apt-get install -yqq software-properties-common python-software-properties && \
    apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python python-pip cron

RUN DEBIAN_FRONTEND=noninteractive apt-get purge -y \
    python-software-properties software-properties-common && \
    apt-get -yqq clean && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set the time zone to the local time zone
RUN echo "America/New_York" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

ADD /scripts /

RUN chmod a+x /*.sh && \
    cd / && \
    mkdir /backups && \
    pip install awscli

ENV HOME /root
ADD backup-job /etc/cron.d/

VOLUME /data
VOLUME /backups

ENTRYPOINT ["/cronstart.sh"]
