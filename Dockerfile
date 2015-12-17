#FROM centos:6
# This is a RHEL 7 image from Redhat
FROM registry.access.redhat.com/rhel7.1

MAINTAINER Couchbase Docker Team <docker@couchbase.com>

USER root

# Install yum dependencies
RUN yum install -y tar \
    && yum clean all
# To satisfy the Couchbase server
RUN yum -y install openssl

# Install gosu for startup script
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.4/gosu-amd64" \
    && curl -o /usr/local/bin/gosu.asc -sSL "https://github.com/tianon/gosu/releases/download/1.4/gosu-amd64.asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

ENV CB_VERSION=4.0.0 \
    CB_RELEASE_URL=http://packages.couchbase.com/releases \
    CB_PACKAGE=couchbase-server-community-4.0.0-centos7.x86_64.rpm \
    PATH=$PATH:/opt/couchbase/bin:/opt/couchbase/bin/tools:/opt/couchbase/bin/install

# Install couchbase
RUN rpm --install $CB_RELEASE_URL/$CB_VERSION/$CB_PACKAGE

#clean the cache
RUN yum clean all


COPY scripts/couchbase-start /usr/local/bin/
COPY functions /etc/init.d/

LABEL Name=rhel7/couchdb
LABEL Release=Latest 
LABEL Vendor=Couchbase 
LABEL Version=4.0.0 

LABEL RUN="docker run -d -p 8091:8091 -p 8092:8092 --restart always --name NAME IMAGE"

ENTRYPOINT ["couchbase-start"]
CMD ["couchbase-server", "--", "-noinput"]
# pass -noinput so it doesn't drop us in the erlang shell

EXPOSE 8091 8092 11207 11210 11211 18091 18092
#VOLUME /opt/couchbase/var
