ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}

ARG VERSION=41.51
RUN yum install -y wget clang perl gcc-gfortran hdf5-devel mpich mpich-devel
ENV PATH=$PATH:/usr/lib64/mpich/bin/

RUN wget https://swanmodel.sourceforge.io/download/zip/swan${VERSION//./}.tar.gz -O /tmp/swan.tar.gz && \
    mkdir -p /opt/swan && tar xvf /tmp/swan.tar.gz -C /opt/swan --strip-components=1 && \
    cd /opt/swan && \
    sed -i '/compiler = \"/c\         \$compiler = \"gfortran\";' platform.pl && \
    make config && \
    make mpi

ENV workdir=/opt/swan
WORKDIR /opt/swan