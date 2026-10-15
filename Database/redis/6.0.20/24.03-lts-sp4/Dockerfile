ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=6.0.20

RUN yum -y update; \
	yum -y install findutils wget gcc make glibc-devel openssl-devel ca-certificates shadow-utils g++ libatomic; \
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
    make -C /redis -j "$(nproc)" all MALLOC=libc; \
    make -C /redis install

COPY <<'ENTRYPOINT_EOF' /entrypoint.sh
#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
	set -- redis-server "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'redis-server' -a "$(id -u)" = '0' ]; then
	find . \! -user redis -exec chown redis '{}' +
	exec gosu redis "$0" "$@"
fi

um="$(umask)"
if [ "$um" = '0022' ]; then
	umask 0077
fi

exec "$@"
ENTRYPOINT_EOF
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