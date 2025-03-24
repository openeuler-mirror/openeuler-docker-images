FROM openeuler/openeuler-binary-base:queens-20.03-lts-sp2

RUN usermod --append --home /run/memcache --groups kolla memcached \
    && mkdir -p /run/memcache \
    && chown -R 42457:42457 /run/memcache

RUN yum -y install memcached && yum clean all && rm -rf /var/cache/yum

USER memcached
