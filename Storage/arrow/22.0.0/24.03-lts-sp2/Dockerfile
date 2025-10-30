ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}

ARG VERSION=22.0.0

RUN yum install -y git gcc gcc-c++ make cmake wget && \
    yum clean all

RUN git clone -b maint-${VERSION} https://github.com/apache/arrow.git && \
    mkdir -p /arrow/cpp/release && \
    cd /arrow/cpp/release && \
    cmake .. && \
    make -j$(nproc) \
    && make install DESTDIR=/usr/local && \
    rm -rf /arrow

WORKDIR /usr/local
CMD ["/bin/bash"]