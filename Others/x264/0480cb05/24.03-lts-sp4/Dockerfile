ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=0480cb05

RUN dnf install -y gcc make curl tar gzip diffutils && \
    if [ "$(uname -m)" = "x86_64" ]; then dnf install -y nasm; fi && \
    dnf clean all

RUN curl -fSL --connect-timeout 30 --retry 3 -o /tmp/x264.tar.gz \
      https://code.videolan.org/videolan/x264/-/archive/${VERSION}/x264-${VERSION}.tar.gz && \
    mkdir -p /x264 && \
    tar -xzf /tmp/x264.tar.gz -C /x264 --strip-components=1 && \
    rm -f /tmp/x264.tar.gz

RUN mkdir -p /x264/x264_build && \
    cd /x264/x264_build && \
    ../configure --enable-shared --enable-pic --prefix=/usr/local && \
    make -j$(nproc) && make install

RUN echo /usr/local/lib > /etc/ld.so.conf.d/x264.conf && ldconfig && \
    x264 --version

WORKDIR /workspace

CMD ["x264", "--help"]
