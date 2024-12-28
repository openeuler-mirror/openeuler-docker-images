ARG BASE=openeuler/openeuler:22.03-lts-sp1

FROM ${BASE}
ARG VERSION=2.3.105-tb
ARG BUILD_DIR=/tmp/build
ARG TARGETARCH
ARG BUILDARCH

RUN yum -y install gcc \
    gcc-c++ \
    git \
    make \
    cmake \
    autoconf \
    automake \
    libcap-devel \
    patch \
    rpm-build \
    rpmdevtools \
    dnf-utils \
    wget \
    ndctl \
    ndctl-devel \
    popt-devel \
    gnulib-devel \
    perl-interpreter \
    asciidoctor \
    meson

COPY rpms/*.rpm ${BUILD_DIR}/
COPY scripts/install_oepkgs.sh ${BUILD_DIR}/
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BUILDARCH="aarch64"; \
    fi; \
    bash -x ${BUILD_DIR}/install_oepkgs.sh ${BUILDARCH} ${BUILD_DIR} && \
    rm -rf ${BUILD_DIR}

COPY scripts/install_ipmctl.sh /tmp/install_ipmctl.sh
COPY patches/install_ipmctl.patch /tmp/install_ipmctl.patch
RUN set -eux; \
    if [ "$TARGETARCH" = "amd64" ]; then \
        IPMCTL_VERSION=03.00.00.0468; \
        cd /tmp; \
        git clone -b v${IPMCTL_VERSION} https://github.com/intel/ipmctl; \
        git clone -b edk2-stable202411  https://github.com/tianocore/edk2.git; \
        cd ipmctl; \
        bash -x ./updateedk.sh; \
        mv /tmp/install_ipmctl.sh ./install_ipmctl.sh; \
        mv /tmp/install_ipmctl.patch ./install_ipmctl.patch; \
        bash -x ./install_ipmctl.sh ./install_ipmctl.patch ${IPMCTL_VERSION}; \
        cd output/rpmbuild/RPMS/x86_64; \
        dnf install -y `ls | grep libipmctl5-${IPMCTL_VERSION}`; \
        dnf install -y `ls | grep libipmctl5-devel-${IPMCTL_VERSION}`; \
        dnf install -y `ls | grep ipmctl-${IPMCTL_VERSION}`; \
        rm -rf /tmp/patches && rm -rf /tmp/edk2 && rm -rf /tmp/ipmctl; \
    fi;

COPY patches/install_dpdk.patch /tmp/install_dpdk.patch
ARG SPDK_VERSION=24.09
RUN cd /tmp && \
    git clone --recurse-submodules --branch v${SPDK_VERSION} https://github.com/spdk/spdk && \
    mv /tmp/install_dpdk.patch /tmp/spdk/install_dpdk.patch && \
    cd spdk && \
    git apply --ignore-space-change --ignore-whitespace --whitespace=nowarn install_dpdk.patch && \
    ./scripts/pkgdep.sh && \
    ./configure && \
    make -j $(nproc) && \
    make install && \
    rm -rf /tmp/spdk

ARG DBENCH_VERSION=4.0
RUN cd /tmp && \
    wget  http://samba.org/ftp/tridge/dbench/dbench-${DBENCH_VERSION}.tar.gz && \
    tar -zxvf dbench-${DBENCH_VERSION}.tar.gz && \
    cd dbench-${DBENCH_VERSION} && \
    bash -x ./autogen.sh && \
    ./configure && \
    make -j $(nproc) && \
    make install && \
    rm -rf /tmp/dbench*

ARG LBZIP_VERSION=2.5
RUN cd /tmp && \
    git clone -b v${LBZIP_VERSION} https://github.com/kjn/lbzip2/ && \
    cd lbzip2 && \
    bash -x ./build-aux/autogen.sh && \
    ./configure --enable-warnings && \
    make V=1 -j $(nproc) && \
    make install && \
    rm -rf /tmp/lbzip2

RUN python3 -m venv /home/daos/venv
ENV PATH=/home/daos/venv/bin:$PATH
ENV VIRTUAL_ENV=/home/daos/venv/
ARG PREFIX=/usr/local/daos

RUN dnf --nodocs -y install \
    bzip2 \
    capstone-devel \
    clang \
    clang-tools-extra \
    CUnit-devel \
    daxctl-devel \
    diffutils \
    e2fsprogs \
    file \
    flex \
    fuse3 \
    fuse3-devel \
    scons \
    glibc-langpack-en \
    golang \
    graphviz \
    help2man \
    hwloc-devel \
    java-1.8.0-openjdk \
    json-c-devel \
    libaio-devel \
    libcmocka-devel \
    libevent-devel \
    libiscsi-devel \
    libtool \
    libtool-ltdl-devel \
    libunwind-devel \
    libuuid-devel \
    libyaml-devel \
    lz4-devel \
    numactl \
    numactl-devel \
    openmpi-devel \
    openssl-devel \
    patchelf \
    pciutils \
    pciutils-devel \
    protobuf-c-devel \
    python3-devel \
    python3-pip \
    sg3_utils \
    sudo \
    systemd \
    valgrind-devel \
    which \
    yasm \
    boost-python3 \
    boost-devel \
    maven

COPY patches/install_daos.patch /tmp/install_daos.patch
ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8
RUN cd /tmp && \
    git clone --recurse-submodules --branch v${VERSION} https://github.com/daos-stack/daos.git && \
    cd daos && \
    mv /tmp/install_daos.patch ./install_daos.patch && \
    git apply --ignore-space-change --ignore-whitespace --whitespace=nowarn install_daos.patch && \
    pip3 install pyelftools && \
    scons --config=force --build-deps=yes install PREFIX=${PREFIX} && \
    rm -rf /tmp/daos

ENV CPATH=${PREFIX}/include
ENV PATH=${PREFIX}/bin/:$PATH

CMD ["daos_server", "version"]