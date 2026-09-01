ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE

ARG HYCOM_VERSION=2.3.01

ENV PATH=/usr/lib64/openmpi/bin:$PATH \
    LD_LIBRARY_PATH=/usr/lib64/openmpi/lib

RUN yum install -y \
        gcc gcc-c++ gcc-gfortran make git openmpi-devel && \
    yum clean all && rm -rf /var/cache/yum

RUN git clone --recursive https://github.com/HYCOM/HYCOM-src.git /src && \
    cd /src && git checkout ${HYCOM_VERSION}

COPY config/generic-gnu-relo_mpi /src/config/generic-gnu-relo_mpi

RUN cd /src && make hycom ARCH=generic-gnu-relo TYPE=mpi

RUN cp /src/hycom /usr/local/bin/hycom && \
    rm -rf /src

RUN ldd /usr/local/bin/hycom | grep -q "not found" && \
    echo "hycom has unresolved shared library dependencies" && exit 1 || \
    echo "hycom shared library dependencies OK"

WORKDIR /workspace
CMD ["/bin/bash"]