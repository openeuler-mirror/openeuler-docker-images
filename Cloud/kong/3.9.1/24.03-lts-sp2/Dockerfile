ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}

ARG VERSION=3.9.1
ARG KONG_REPO
ARG TARGETARCH
ARG BUILDARCH
ARG DOWNLOAD_URL

RUN yum install -y --nodocs \
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
        unzip \
        libxcrypt && \
    yum clean all

RUN if [ "$TARGETARCH" = "amd64" ]; then \
        BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BUILDARCH="aarch64"; \
    fi; \
    KONG_REPO=$(echo ${VERSION%.*} | sed 's/\.//') && \
    DOWNLOAD_URL=https://packages.konghq.com/public/gateway-${KONG_REPO}/rpm/el/9/${BUILDARCH}/kong-${VERSION}.el9.${BUILDARCH}.rpm && \
    curl -fSL -o /kong.rpm $DOWNLOAD_URL && \
    yum install -y /kong.rpm && \
    rm -rf /kong.rpm

RUN chown kong:0 /usr/local/bin/kong && \
    chown -R kong:0 /usr/local/kong && \
    ln -sf /usr/local/openresty/bin/resty /usr/local/bin/resty && \
    ln -sf /usr/local/openresty/luajit/bin/luajit /usr/local/bin/luajit && \
    ln -sf /usr/local/openresty/luajit/bin/luajit /usr/local/bin/lua && \
    ln -sf /usr/local/openresty/nginx/sbin/nginx /usr/local/bin/nginx && \
    ln -sf /usr/lib64/libcrypt.so.1 /usr/lib64/libcrypt.so.2 && \
    kong version

RUN curl -O https://raw.githubusercontent.com/Kong/docker-kong/master/docker-entrypoint.sh && \
    chmod +x /docker-entrypoint.sh

USER kong
ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 8000 8443 8001 8444
STOPSIGNAL SIGQUIT
HEALTHCHECK --interval=60s --timeout=10s --retries=10 CMD kong-health

CMD ["kong", "docker-start"]

