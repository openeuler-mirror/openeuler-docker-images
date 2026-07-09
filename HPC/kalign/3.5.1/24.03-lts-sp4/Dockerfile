ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE
ARG VERSION=3.5.1
ARG TAG=v${VERSION}
RUN yum install -y \
        gcc gcc-c++ make cmake git && \
    yum clean all && rm -rf /var/cache/yum
RUN git clone -b ${TAG} https://github.com/TimoLassmann/kalign.git /opt/kalign && \
    cd /opt/kalign && \
    mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DUSE_OPENMP=OFF -DUSE_THREADPOOL=ON .. && \
    make -j$(nproc) && \
    make install && \
    rm -rf /opt/kalign/.git /opt/kalign/build
WORKDIR /workspace
CMD ["/bin/bash"]