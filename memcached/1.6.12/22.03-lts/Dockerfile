FROM openeuler/openeuler:22.03-lts
MAINTAINER heguofeng <heguofeng@openeuler.sh>
RUN yum -y update && \
    yum -y install memcached && \
    yum clean all

EXPOSE 11211
CMD ["memcached", "-u", "daemon"]
