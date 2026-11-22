ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=3.16.2

RUN dnf install -y \
      gcc gcc-c++ \
      meson ninja-build pkgconf \
      tar curl && \
    dnf clean all && \
    rm -rf /var/cache/dnf

WORKDIR /opt

RUN curl -fSL --retry 3 --connect-timeout 20 -o fuse-${VERSION}.tar.gz \
      https://github.com/libfuse/libfuse/releases/download/fuse-${VERSION}/fuse-${VERSION}.tar.gz && \
    tar -xzf fuse-${VERSION}.tar.gz && \
    rm -f fuse-${VERSION}.tar.gz

WORKDIR /opt/fuse-${VERSION}

RUN meson setup build --libdir=lib && \
    DESTDIR=/opt/fuse-install ninja -C build install

FROM ${BASE}

COPY --from=builder /opt/fuse-install/usr/local/ /usr/local/

RUN echo /usr/local/lib > /etc/ld.so.conf.d/libfuse3.conf && \
    ldconfig

USER root

CMD ["fusermount3", "-V"]