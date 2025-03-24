ARG BASE=openeuler/openeuler:22.03-lts-sp3
FROM ${BASE}

ARG VERSION=0.7.18
ARG TARGETARCH

RUN yum -y install make gcc zlib-devel && \
    mkdir -p /tmp/bwa && cd /tmp/bwa && \
    curl -fSL -o bwa.tar.gz https://github.com/lh3/bwa/archive/v${VERSION}.tar.gz && \
    tar -xvf bwa.tar.gz -C /tmp/bwa --strip-components=1 && \
    rm -f bwa.tar.gz && \
    make clean && make -j "$(nproc)" && \ 
    mkdir -p /usr/local/bwa/bin && mv /tmp/bwa/bwa /usr/local/bwa/bin/ && \
    rm -rf /tmp/bwa && \
    yum remove -y make gcc zlib-devel && yum clean all

ENV PATH=/usr/local/bwa/bin:$PATH

CMD ["bwa"]