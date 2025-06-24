ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} AS builder

ARG VERSION=29Aug2024

RUN dnf update -y \
    && dnf install -y wget vim gcc-c++ make openmpi-devel mpich-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN wget https://github.com/lammps/lammps/archive/refs/tags/stable_${VERSION}.tar.gz \
    && tar -zxvf stable_${VERSION}.tar.gz \
    && rm -f stable_${VERSION}.tar.gz

WORKDIR /opt/lammps-stable_${VERSION}

RUN cp examples/melt/in.melt  src/

WORKDIR /opt/lammps-stable_${VERSION}/src

RUN make mpi

CMD ["./lmp_mpi", "-in", "in.melt"]
