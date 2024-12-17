ARG BASE=openeuler/openeuler:24.03-lts
FROM ${BASE}
ARG VERSIO=3.4.0
ARG TARGETARCH

RUN dnf install -y --nodocs \
    findutils \
    shadow-utils \
    libyaml-devel \
    openssl \
    hostname \
    openssl-devel \
    pcre \
    pcre-devel \
    perl \
    perl-Time-HiRes \
    zlib \
    zlib-devel \
    unzip && \
    dnf clean all

COPY kong.${VERSIO}.${TARGETARCH}.rpm /tmp/kong.${VERSIO}.${TARGETARCH}.rpm
RUN rpm -iv /tmp/kong.${VERSIO}.${TARGETARCH}.rpm && \
    dnf clean all && \
    rm /tmp/kong.${VERSIO}.${TARGETARCH}.rpm

RUN chown kong:0 /usr/local/bin/kong && \
    chown -R kong:0 /usr/local/kong

RUN ln -sf /usr/local/openresty/bin/resty /usr/local/bin/resty && \
    ln -sf /usr/local/openresty/luajit/bin/luajit /usr/local/bin/luajit && \
    ln -sf /usr/local/openresty/luajit/bin/luajit /usr/local/bin/lua && \
    ln -sf /usr/local/openresty/nginx/sbin/nginx /usr/local/bin/nginx && \
    kong version

COPY docker-entrypoint.sh /usr/local/kong/docker-entrypoint.sh

RUN chmod +x /usr/local/kong/docker-entrypoint.sh

USER kong

ENTRYPOINT ["/usr/local/kong/docker-entrypoint.sh"]

EXPOSE 8000 8443 8001 8444

STOPSIGNAL SIGQUIT

HEALTHCHECK --interval=60s --timeout=10s --retries=10 CMD kong-health

CMD ["kong", "docker-start"]
