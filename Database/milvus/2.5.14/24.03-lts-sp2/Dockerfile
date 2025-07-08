ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE} AS builder

ARG VERSION=2.5.14
ARG GOLANG_VERSION=1.24.2
ARG TARGETARCH

RUN yum install -y \
        sudo vim wget gcc g++ cmake make git which \
        gfortran zip unzip libatomic texinfo numa* ninja* libstdc* pkg-config libuuid-devel \
        python3-pip openblas-devel libaio perl-IPC-Cmd libasan libomp hdf5 hdf5-devel && \
    yum clean all && \
    wget -O go.tar.gz https://golang.google.cn/dl/go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz && \
    tar -xvf go.tar.gz -C /usr/local && \
    rm -rf go.tar.gz
ENV PATH=/usr/local/go/bin:$PATH

RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain=1.73 -y && \
    pip install conan==1.61.0
ENV PATH=/root/.cargo/bin:$PATH

RUN git clone -b v${VERSION} https://github.com/milvus-io/milvus.git && \
    cd milvus/ && \
    ./scripts/install_deps.sh && \
    CXXFLAGS="-I/usr/include/openblas" make build-cpp && \
    make build-go


FROM openeuler/openeuler:24.03-lts-sp2

ARG TARGETARCH

RUN yum install -y libatomic openblas-devel libomp libstdc++ && \
    yum clean all

RUN curl -fSL -o etcd-v3.5.0-linux-$TARGETARCH.tar.gz https://github.com/etcd-io/etcd/releases/download/v3.5.0/etcd-v3.5.0-linux-$TARGETARCH.tar.gz && \
    tar zxvf etcd-v3.5.0-linux-$TARGETARCH.tar.gz && \
    cp -r etcd-v3.5.0-linux-$TARGETARCH /usr/local/etcd && \
    rm -rf etcd-v3.5.0-linux-$TARGETARCH.tar.gz etcd-v3.5.0-linux-$TARGETARCH
ENV PATH=/usr/local/etcd:$PATH

RUN curl -fSL -o minio https://dl.min.io/server/minio/release/linux-$TARGETARCH/minio && \
    chmod +x ./minio && \
    mv ./minio /usr/bin/

WORKDIR /milvus

COPY --from=builder /milvus/internal/core/output/lib64/ /milvus/lib64/
COPY --from=builder /milvus/internal/core/output/lib/*.so* /milvus/lib/
COPY --from=builder /milvus/configs /milvus/configs
COPY --from=builder /milvus/bin/ /milvus/bin/

ENV LD_LIBRARY_PATH=/milvus/lib:/milvus/lib64:/lib64
ENV PATH=$PATH:/milvus/bin/