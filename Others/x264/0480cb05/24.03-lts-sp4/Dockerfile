ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=0480cb05

RUN dnf install -y gcc make git diffutils && \
    if [ "$(uname -m)" = "x86_64" ]; then dnf install -y nasm; fi && \
    dnf clean all

# Full history is required by x264's revision-based version script.
RUN git clone https://code.videolan.org/videolan/x264.git /x264 && \
    cd /x264 && git checkout ${VERSION}

RUN mkdir -p /x264/x264_build && \
    cd /x264/x264_build && \
    ../configure --enable-shared --enable-pic --prefix=/usr/local && \
    make -j$(nproc) && make install

RUN echo /usr/local/lib > /etc/ld.so.conf.d/x264.conf && ldconfig && \
    x264 --version | grep -F "x264 0.165.3223 "

WORKDIR /workspace

CMD ["x264", "--help"]
