ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} as BUILDER
ARG VERSION=2.41

RUN dnf update -y && \
    dnf install -y \
    bison \
    gcc \
    gcc-c++ \
    make \
    git \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

WORKDIR /opt
RUN git clone -b release/${VERSION}/master --depth=1 https://sourceware.org/git/glibc.git

WORKDIR /opt/glibc/build
RUN ../configure --prefix=/opt/glibc-${VERSION} && \
    make -j$(nproc) && \
    make install

FROM ${BASE}
ARG VERSION=2.41
COPY --from=BUILDER /opt/glibc-${VERSION} /opt/glibc-${VERSION}
CMD ["/opt/glibc-2.41/bin/ldd", "--version"]
