ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=8.2.1

RUN yum -y update; \
	yum -y install findutils wget gcc make glibc-devel openssl-devel ca-certificates shadow-utils g++; \
    groupadd -r -g 909 redis; \
	useradd -r -g redis -u 909 redis

ENV GOSU_VERSION 1.17
RUN wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${TARGETARCH}"; \
    chmod +x /usr/local/bin/gosu; \
    wget -O redis.tar.gz https://github.com/redis/redis/archive/refs/tags/${VERSION}.tar.gz; \
    mkdir -p /redis; tar -vxzf redis.tar.gz -C /redis --strip-components=1; \
    rm -rf redis.tar.gz; \
    grep -E '^ *createBoolConfig[(]"protected-mode",.*, *1 *,.*[)],$' /redis/src/config.c; \
    sed -ri 's!^( *createBoolConfig[(]"protected-mode",.*, *)1( *,.*[)],)$!\10\2!' /redis/src/config.c; \
    grep -E '^ *createBoolConfig[(]"protected-mode",.*, *0 *,.*[)],$' /redis/src/config.c; \
    extraJemallocConfigureFlags="--build=$TARGETARCH"; \
    case "${TARGETARCH}" in \
    	amd64) extraJemallocConfigureFlags="$extraJemallocConfigureFlags --with-lg-page=12" ;; \
    	*) extraJemallocConfigureFlags="$extraJemallocConfigureFlags --with-lg-page=16" ;; \
    esac; \
    extraJemallocConfigureFlags="$extraJemallocConfigureFlags --with-lg-hugepage=21"; \
    grep -F 'cd jemalloc && ./configure ' /redis/deps/Makefile; \
    sed -ri 's!cd jemalloc && ./configure !&'"$extraJemallocConfigureFlags"' !' /redis/deps/Makefile; \
    grep -F "cd jemalloc && ./configure $extraJemallocConfigureFlags " /redis/deps/Makefile; \
    export BUILD_TLS=yes; \
    make -C /redis/deps/fast_float; \
    make -C /redis -j "$(nproc)" all MALLOC=libc; \
    make -C /redis install

COPY entrypoint.sh /
RUN serverMd5="$(md5sum /usr/local/bin/redis-server | cut -d' ' -f1)"; export serverMd5; \
    find /usr/local/bin/redis* -maxdepth 0 \
        -type f -not -name redis-server \
        -exec sh -eux -c ' \
            md5="$(md5sum "$1" | cut -d" " -f1)"; \
            test "$md5" = "$serverMd5"; \
        ' -- '{}' ';' \
        -exec ln -svfT 'redis-server' '{}' ';' \
    ; \
    rm -rf /redis; \
    chmod 755 /entrypoint.sh; \
    mkdir /data; chown redis:redis /data; \
    yum -y remove wget gcc make; \
    yum clean all

VOLUME /data
WORKDIR /data

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 6379
CMD ["redis-server"]