ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=2025.09.05
ENV MOOSE_VERSION=${VERSION}

RUN yum install -y \
        gcc gcc-c++ gcc-gfortran make cmake \
        openmpi-devel openblas-devel eigen3-devel libtirpc-devel zlib-devel \
        python3 python3-devel python3-pyyaml python3-packaging python3-jinja2 \
        perl autoconf automake libtool patchelf \
        curl git tar gzip xz which sed grep diffutils coreutils findutils file && \
    yum clean all

COPY build.sh /opt/build.sh
RUN chmod +x /opt/build.sh && /opt/build.sh && rm -f /opt/build.sh

USER root
