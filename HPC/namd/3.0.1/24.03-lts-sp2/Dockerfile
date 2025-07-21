ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE} AS builder
ARG TARGETARCH
ARG BUILDARCH
ARG NAMD_ARCH
ARG VERSION=3.0.1

RUN dnf update -y \
    && dnf install -y gcc gcc-c++ gcc-gfortran make cmake patch wget tcl tcl-devel fftw fftw-devel findutils \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN wget https://www.ks.uiuc.edu/Research/namd/${VERSION}/download/453167/NAMD_${VERSION}_Source.tar.gz

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      BUILDARCH="x86_64"; \
      NAMD_ARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      BUILDARCH="arm8"; \
      NAMD_ARCH="ARM64"; \
    fi \
    && mkdir namd \
    && tar xf NAMD_${VERSION}_Source.tar.gz -C /opt/namd --strip-components=1 \
    && cd namd \
    && tar xf charm-8.0.0.tar \
    && cd charm-8.0.0 \
    && ./build charm++ multicore-linux-${BUILDARCH} --with-production \
    && cd .. \
    && ./config Linux-${NAMD_ARCH}-g++.arch --charm-arch multicore-linux-${BUILDARCH} --without-tcl --without-fftw \
    && cd Linux-${NAMD_ARCH}-g++.arch/ \
    && make -j $(nproc)

FROM ${BASE}

COPY --from=builder /opt/namd /opt/namd

WORKDIR /opt/namd/Linux-ARM64-g++.arch

CMD ["./namd3", "src/alanin"]
