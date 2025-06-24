ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=1.7.18

RUN dnf install -y \
    wget \
    gcc-c++ \
    make \
    cmake \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN wget https://github.com/DaveGamble/cJSON/archive/refs/tags/v${VERSION}.tar.gz \
    && tar -zxvf  v${VERSION}.tar.gz \
    && rm -f v${VERSION}.tar.gz

WORKDIR /opt/cJSON-${VERSION}/build

RUN cmake .. -DENABLE_CJSON_UTILS=On -DENABLE_CJSON_TEST=Off -DCMAKE_INSTALL_PREFIX=/usr \
    && make -j$(nproc) \
    && make install

CMD ["bash"]
