ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}

ARG VERSION=1920

RUN dnf update -y \
    && dnf install -y git cmake gcc-c++ make \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN git clone https://chromium.googlesource.com/libyuv/libyuv \
    && cd libyuv \
    && mkdir build \
    && cd build \
    && cmake -DBUILD_SHARED_LIBS=ON .. \
    && make -j$(nproc) \
    && make install

ENV LD_LIBRARY_PATH=/usr/local/lib:/libyuv/build:$LD_LIBRARY_PATH

CMD ["bash"]