ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} as BUILDER
ARG VERSION=1.37.0

RUN dnf update -y \
    && dnf install -y gcc make wget findutils diffutils \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN wget https://busybox.net/downloads/busybox-${VERSION}.tar.bz2 \
    && tar -jxvf busybox-${VERSION}.tar.bz2 \
    && cd busybox-${VERSION} \
    && make allnoconfig \
    && make CONFIG_PREFIX=/usr/local/busybox install

ENV PATH /usr/local/busybox/bin:$PATH

CMD ["busybox"]
