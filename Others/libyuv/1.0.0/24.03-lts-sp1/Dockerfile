ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=1.0.0

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

CMD ["bash"]