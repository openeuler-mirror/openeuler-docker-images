ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE
ARG VERSION=v2.3.0
RUN yum install -y \
        git gcc gcc-c++ make cmake which \
        openmpi-devel hdf5-devel && \
    yum clean all && rm -rf /var/cache/yum
ENV PATH=/usr/lib64/openmpi/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/lib64/openmpi/lib
RUN git clone -b ${VERSION} https://gitlab.com/unigespc/palabos.git /opt/palabos && \
    cd /opt/palabos/examples/showCases/cavity2d/build && \
    cmake .. && \
    make -j$(nproc)
WORKDIR /opt/palabos
CMD ["/bin/bash"]