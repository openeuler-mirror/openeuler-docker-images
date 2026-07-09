ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE
ARG VERSION=5.2.4
ARG TAG=v${VERSION}
RUN yum install -y \
        gcc gcc-c++ make cmake git && \
    yum clean all && rm -rf /var/cache/yum
RUN git clone -b ${TAG} https://github.com/USEPA/Stormwater-Management-Model.git /opt/swmm && \
    cd /opt/swmm && \
    mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTS=OFF .. && \
    make -j$(nproc) && \
    make install && \
    rm -rf /opt/swmm/.git /opt/swmm/build
WORKDIR /workspace
CMD ["/bin/bash"]