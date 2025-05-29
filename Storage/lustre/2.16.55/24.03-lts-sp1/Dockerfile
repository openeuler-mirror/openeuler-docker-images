ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=2.16.55

RUN dnf install -y gcc make autoconf automake libtool flex bison \
    pciutils-devel kernel-devel kernel-headers elfutils-libelf-devel \
    numactl-devel libuuid-devel keyutils-libs keyutils-libs-devel \
    libnl3-devel libyaml-devel git \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN git clone -b ${VERSION} --depth 1 git://git.whamcloud.com/fs/lustre-release.git \
    && cd lustre-release \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install \
    && ldconfig \
    && cd .. \
    && rm -rf lustre-release

CMD ["lfs", "--version"]