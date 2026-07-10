ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=8.1.0
ARG TARGETARCH

ENV LANG=C.UTF-8 \
    SPECFEM_HOME=/opt/specfem3d_globe \
    PATH=/opt/specfem3d_globe/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    MAX_JOBS=2

RUN dnf -y update && \
    dnf -y install --nodocs --setopt=install_weak_deps=False \
        gcc-gfortran gcc-c++ openmpi-devel make git wget curl && \
    dnf clean all && rm -rf /var/cache/dnf

WORKDIR /opt

RUN git clone -b v${VERSION} --depth 1 https://github.com/SPECFEM/specfem3d_globe.git ${SPECFEM_HOME}

WORKDIR ${SPECFEM_HOME}

RUN ./configure FC=gfortran CC=gcc MPIFC=mpif90 && \
    make all -j2

LABEL org.opencontainers.image.title="specfem3d_globe" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.description="SPECFEM3D_GLOBE global and regional seismic wave propagation simulator"

CMD ["bash"]