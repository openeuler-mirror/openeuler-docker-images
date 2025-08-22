ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=2.16.57

RUN dnf install -y wget gcc make autoconf automake libtool flex bison \
    pciutils-devel kernel-devel kernel-headers elfutils-libelf-devel \
    numactl-devel libuuid-devel keyutils-libs keyutils-libs-devel \
    libnl3-devel libyaml-devel git \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN wget https://github.com/lustre/lustre-release/archive/refs/tags/${VERSION}.tar.gz \
    && tar -zxvf ${VERSION}.tar.gz \
    && cd lustre-release-${VERSION} \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install \
    && ldconfig \
    && cd .. \
    && rm -rf lustre-release-${VERSION} \
    && rm -rf ${VERSION}.tar.gz

CMD ["lfs", "--version"]