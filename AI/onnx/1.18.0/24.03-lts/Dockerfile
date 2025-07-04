ARG BASE=openeuler/openeuler:24.03-lts
ARG VERSION=v1.18.0

FROM ${BASE}

ARG VERSION

RUN yum update -y && \
    yum install -y \
        python3-devel \
        python3-pip \
        git \
        g++ \
        cmake \
        protobuf-devel \
        protobuf-compiler && \
    yum clean all &&\
    rm -fr /var/cache/yum
    
WORKDIR /workspace

RUN git clone -b ${VERSION} https://github.com/onnx/onnx.git

WORKDIR /workspace/onnx

RUN git submodule update --init --recursive

ENV CMAKE_ARGS="-DONNX_USE_PROTOBUF_SHARED_LIBS=ON"

RUN pip install -e . -v