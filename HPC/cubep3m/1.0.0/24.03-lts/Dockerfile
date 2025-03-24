ARG BASE=openeuler/openeuler:24.03-lts
FROM ${BASE}

# At this monment, cubep3m has no release
# we might as well consider the `master` branch as version 1.0.0
ARG VERSION=1.0.0
ARG TARGETARCH
ARG BUILD_ARG
RUN yum install -y git gfortran openmpi-devel make && \
    curl -fSL -o /tmp/fftw-2.1.5.tar.gz https://fftw.org/pub/fftw/fftw-2.1.5.tar.gz && \
    cd /tmp && tar xvf fftw-2.1.5.tar.gz && \
    cd fftw-2.1.5 && \
    if [ "$TARGETARCH" = "arm64" ]; then \
        BUILD_ARG="--build=aarch64-unknown-linux-gnu"; \
    fi; \
    ./configure \
        ${BUILD_ARG} \
        --enable-mpi \
        --enable-shared \
        --enable-type-prefix \
        --enable-threads \
        --enable-float && \
    make -j "$(nproc)" && make install && \
    rm -rf /tmp/fftw* && \
    yum clean all

WORKDIR /opt
RUN git clone https://github.com/jharno/cubep3m && \
    cd cubep3m && source ./README && \
    cd source_threads && \
    sed -i '/FFLAGS=/c\FFLAGS= -fallow-argument-mismatch -fallow-invalid-boz -fopenmp \$(ARG_MISMATCH) -Wno-error -ffixed-line-length-none -ffree-form -ffree-line-length-none -cpp -g -O3 -fpic -DDIAG -DBINARY -DNGP -DPPINT -DMPI_TIME  -DLRCKCORR -DNGPH -DDISP_MESH #-DPP_EXT  #-DPID_FLAG #-DDEBUG_PP_EXT #-DREAD_SEED #-DDISP_MESH -DPID_FLAG #-DDEBUG' Makefile_gnu_sfftw2 && \
    make -f Makefile_gnu_sfftw2

WORKDIR /opt/cubep3m