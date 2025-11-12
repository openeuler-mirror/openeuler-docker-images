ARG BASE=openeuler/openeuler:24.03-lts-sp2
ARG VERSION=1.0.0

FROM ${BASE}

ARG VERSION

RUN yum update -y && \
    yum install -y git gcc-c++ python3-devel python3-pip

ARG EXECUTORCH_URL=https://github.com/pytorch/executorch.git
RUN git clone -b v${VERSION} ${EXECUTORCH_URL} && \
    cd executorch && \
    ./install_executorch.sh

CMD ["/bin/bash"]