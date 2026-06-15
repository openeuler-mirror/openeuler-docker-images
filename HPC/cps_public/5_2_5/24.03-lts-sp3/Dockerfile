ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG VERSION=5_2_5
ARG TARGETARCH

RUN dnf install -y \
      git gcc gcc-c++ make \
      autoconf automake libtool && \
    dnf clean all

WORKDIR /build
RUN git clone --depth 1 --branch v${VERSION} https://github.com/RBC-UKQCD/CPS_public.git && \
    mkdir -p cps-build && cd cps-build && \
    case ${TARGETARCH} in \
      amd64) BUILD_TRIPLE=x86_64-pc-linux-gnu ;; \
      arm64) BUILD_TRIPLE=aarch64-unknown-linux-gnu ;; \
    esac && \
    ../CPS_public/cps_pp/configure --enable-target=noarch --build=${BUILD_TRIPLE} CXXFLAGS=-std=gnu++98 && \
    sed -i 's/^all: rpcgenvml vml cps copy_testdir archive/all: cps copy_testdir archive/' Makefile && \
    sed -i 's/^recurse: vml/recurse:/' Makefile && \
    make && \
    cp cps.a /usr/local/lib/ && \
    cp -r ../CPS_public/cps_pp/include /usr/local/include/cps

WORKDIR /workspace
