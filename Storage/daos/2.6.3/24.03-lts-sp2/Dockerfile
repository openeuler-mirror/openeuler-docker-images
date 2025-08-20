ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}
ARG TARGETARCH
ARG VERSION=2.6.3
ENV LANG=en_US.UTF-8

RUN dnf update -y \
    && dnf install -y wget git boost-python3 bzip2 capstone-devel clang clang-tools-extra cmake CUnit-devel \
    daxctl-devel diffutils e2fsprogs file flex fuse3 gcc gcc-c++ glibc-langpack-en golang graphviz \
    help2man hwloc-devel java-1.8.0-openjdk json-c-devel libaio-devel libcmocka-devel libevent-devel  \
    libiscsi-devel libtool libtool-ltdl-devel libunwind-devel libuuid-devel libyaml-devel Lmod lz4-devel \
    make ndctl ndctl-devel numactl numactl-devel openmpi-devel openssl-devel patch patchelf pciutils pciutils-devel \
    protobuf-c-devel python3-devel python3-pip sg3_utils sudo systemd valgrind-devel which yasm maven boost-devel \
    && dnf clean all && rm -rf /var/cache/dnf/*

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      wget https://github.com/intel/ipmctl/releases/download/v03.00.00.0499/libipmctl5-03.00.00.499-1.el8.x86_64.rpm; \
      wget https://github.com/intel/ipmctl/releases/download/v03.00.00.0499/libipmctl5-devel-03.00.00.499-1.el8.x86_64.rpm; \
      dnf install -y libipmctl5-03.00.00.499-1.el8.x86_64.rpm libipmctl5-devel-03.00.00.499-1.el8.x86_64.rpm; \
      rm -f libipmctl5-*.rpm; \
    fi

RUN git clone -b v${VERSION} --depth 1 --recurse-submodules https://github.com/daos-stack/daos.git

WORKDIR /daos

RUN pip3 --no-cache-dir install --upgrade pip \
    && pip3 install -r requirements-build.txt \
    && scons --jobs $(nproc) --config=force --build-deps=yes install

ENV CPATH=/daos/install/include/:$CPATH
ENV PATH=/daos/install/bin/:${daospath}/install/sbin:$PATH

CMD ["daos", "--help"]