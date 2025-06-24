ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} as BUILDER
ARG VERSION=2.41

RUN dnf update -y && \
    dnf install -y \
    bison \
    gcc \
    gcc-c++ \
    make \
    wget \
    xz \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

WORKDIR /opt

RUN wget https://mirrors.tuna.tsinghua.edu.cn/gnu/glibc/glibc-${VERSION}.tar.xz \
    && tar -xvf  glibc-${VERSION}.tar.xz \
    && rm -f glibc-${VERSION}.tar.xz

WORKDIR /opt/glibc-${VERSION}/build

RUN ../configure --prefix=/usr/local/glibc && \
    make -j$(nproc) && \
    make install

FROM ${BASE}
COPY --from=BUILDER /usr/local/glibc /usr/local/glibc
WORKDIR /usr/local/glibc
CMD ["./bin/ldd", "--version"]
