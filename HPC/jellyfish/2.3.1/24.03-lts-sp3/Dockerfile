ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE
ARG VERSION=2.3.1
RUN yum install -y \
        gcc gcc-c++ make which curl \
        zlib-devel openssl-devel && \
    yum clean all && rm -rf /var/cache/yum
RUN curl -L -o jellyfish-${VERSION}.tar.gz \
        https://github.com/gmarcais/Jellyfish/releases/download/v${VERSION}/jellyfish-${VERSION}.tar.gz && \
    tar -xzf jellyfish-${VERSION}.tar.gz && \
    cd jellyfish-${VERSION} && \
    ./configure --prefix=/usr && \
    make -j $(nproc) && \
    make install && \
    ldconfig && \
    cd / && rm -rf jellyfish-${VERSION} jellyfish-${VERSION}.tar.gz
WORKDIR /workspace
CMD ["/bin/bash"]