ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=master

RUN dnf install -y git gcc make && dnf clean all

WORKDIR /opt
RUN git clone https://github.com/diegocaro/compression.git /opt/compression && \
    cd /opt/compression && \
    git checkout ${VERSION} && \
    make CFLAGS="-Wall -O3" && \
    cp howtouse /usr/local/bin/howtouse

WORKDIR /opt/compression
CMD ["/bin/bash"]