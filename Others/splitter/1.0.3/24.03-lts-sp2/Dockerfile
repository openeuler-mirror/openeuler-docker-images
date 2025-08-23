ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}

ARG VERSION=1.0.3

RUN dnf install -y \
    python3-dnf \
    git \
    python3-pip \
    cpio \
    binutils \
    file && \
    dnf clean all

RUN git clone -b v${VERSION} --depth 1 https://gitee.com/openeuler/splitter.git /splitter && \
    cd /splitter && \
    pip3 install -i https://repo.huaweicloud.com/repository/pypi/simple . && \
    rm -rf /splitter

WORKDIR /

CMD ["/bin/bash"]
