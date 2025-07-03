ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=19.0.1

RUN yum install -y git gcc gcc-c++ make cmake wget && \
    yum clean all

RUN git clone -b maint-${VERSION} https://github.com/apache/arrow.git && \
    mkdir -p /arrow/cpp/release && \
    cd /arrow/cpp/release && \
    camke .. && \
    make -j$(nproc) \
    && make install DESTDIR=/usr/local && \
    rm -rf /arrow

WORKDIR /usr/local
CMD ["/bin/bash"]