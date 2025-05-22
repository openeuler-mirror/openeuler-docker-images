ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} as BUILDER
ARG VERSION=1.1

RUN dnf update -y && \
    dnf install -y \
    wget \
    gcc \
    make \
    patch \
    util-linux-devel \
    libuuid-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

WORKDIR /opt

COPY Export-CACHED_UUID-and-CACHED_LABEL.patch .

RUN wget https://git.kernel.org/pub/scm/linux/kernel/git/colyli/bcache-tools.git/snapshot/bcache-tools-${VERSION}.tar.gz \
    && tar -zxvf bcache-tools-${VERSION}.tar.gz \
    && rm -f bcache-tools-${VERSION}.tar.gz

WORKDIR /opt/bcache-tools-${VERSION}

RUN mkdir -p /usr/share/man/man8 \
    && patch -p1 < ../Export-CACHED_UUID-and-CACHED_LABEL.patch \
    && make -j$(nproc) \
    && make install

CMD ["make-bcache"]
