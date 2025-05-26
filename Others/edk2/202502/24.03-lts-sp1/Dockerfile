ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=202502

RUN dnf install -y git gcc-c++ make libuuid-devel python \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

WORKDIR /opt

RUN git clone -b edk2-stable${VERSION} https://github.com/tianocore/edk2 && \
    cd edk2 && \
    git submodule update --init --recursive

WORKDIR /opt/edk2

RUN make -C BaseTools

CMD ["bash"]
