ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE AS builder

ARG VERSION=2.16.0

RUN dnf install -y \
      gcc gcc-c++ make cmake git \
      autoconf automake libtool \
      libstdc++-static libatomic \
      openssl-devel && \
    dnf clean all

RUN curl -fSL --connect-timeout 30 --retry 3 -o kvrocks.tar.gz \
      https://github.com/apache/kvrocks/archive/refs/tags/v${VERSION}.tar.gz && \
    mkdir -p /kvrocks && \
    tar -zxf kvrocks.tar.gz -C /kvrocks --strip-components=1 && \
    rm -rf kvrocks.tar.gz && \
    cd /kvrocks && \
    ./x.py build --compiler=gcc \
      -DENABLE_OPENSSL=ON \
      -DPORTABLE=1 \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_EXE_LINKER_FLAGS=-latomic \
      -j $(nproc)

FROM $BASE

RUN dnf install -y \
      shadow-utils binutils \
      redis libatomic && \
    dnf clean all && \
    groupadd -r kvrocks && \
    useradd -r -g kvrocks kvrocks && \
    mkdir -p /var/run/kvrocks /var/lib/kvrocks && \
    chown -R kvrocks:kvrocks /var/run/kvrocks /var/lib/kvrocks

COPY --from=builder /kvrocks/build/kvrocks /usr/local/bin/kvrocks
COPY --from=builder /kvrocks/kvrocks.conf /etc/kvrocks/kvrocks.conf
COPY --from=builder /kvrocks/LICENSE /kvrocks/NOTICE /usr/share/licenses/kvrocks/
COPY --from=builder /kvrocks/licenses /usr/share/licenses/kvrocks/licenses

ENV MALLOC_CONF="prof:true,prof_active:false,background_thread:true"

EXPOSE 6666

VOLUME /var/lib/kvrocks

USER kvrocks

HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
    CMD redis-cli -p 6666 PING | grep -E '(PONG|NOAUTH)' || exit 1

ENTRYPOINT ["kvrocks", "-c", "/etc/kvrocks/kvrocks.conf", "--dir", "/var/lib/kvrocks", "--pidfile", "/var/run/kvrocks/kvrocks.pid", "--bind", "0.0.0.0"]
