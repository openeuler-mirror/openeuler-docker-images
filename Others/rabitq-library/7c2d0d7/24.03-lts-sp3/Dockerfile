ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG VERSION=7c2d0d7

RUN dnf install -y git && dnf clean all

WORKDIR /workspace
RUN git clone https://github.com/VectorDB-NTU/RaBitQ-Library.git && \
    cd RaBitQ-Library && git checkout ${VERSION} && \
    cp -r include /usr/local/include/rabitq
