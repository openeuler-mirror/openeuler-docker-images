FROM openeuler/openeuler:22.03-lts
MAINTAINER heguofeng <heguofeng@openeuler.sh>
RUN yum -y update && \
    yum -y install sudo util-linux findutils redis6 && \
    yum clean all

RUN mkdir /data && chown redis:redis /data
VOLUME /data
WORKDIR /data

ENV REDIS_VERSION 6.2.7
ENV GOSU_VERSION 1.12

COPY gosu-amd64 /usr/local/bin/gosu_amd64
COPY gosu-arm64 /usr/local/bin/gosu_arm64
COPY entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/entrypoint.sh && \
    chmod 755 /usr/local/bin/gosu_amd64 && \
    chmod 755 /usr/local/bin/gosu_arm64

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 6379
CMD ["redis-server"]
