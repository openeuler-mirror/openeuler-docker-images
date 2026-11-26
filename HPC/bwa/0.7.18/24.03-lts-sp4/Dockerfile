ARG BASE=openeuler/openeuler:24.03-lts-sp4
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

# openEuler x86 门禁的 bwa_test.sh 会起容器等日志出现 "bwa" 并校验状态为
# running；bwa 无参数时只打印用法就退出，所以这里先输出版本信息再常驻。
CMD ["/bin/bash", "-c", "bwa 2>&1 | head -n 5; exec sleep infinity"]