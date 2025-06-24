ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=5.8.3

RUN yum install -y git python3-pip && \
    yum clean all && \
    pip install pandas bio

RUN git clone -b ${VERSION} https://gitlab.com/ezlab/busco.git && \
    cd busco/ && \
    python3 -m pip install .