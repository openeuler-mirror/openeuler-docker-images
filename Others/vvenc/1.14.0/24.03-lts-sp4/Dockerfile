ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=1.14.0

RUN dnf install -y git gcc gcc-c++ make cmake && dnf clean all

RUN git clone -b v${VERSION} --depth 1 https://github.com/fraunhoferhhi/vvenc.git && \
    cd vvenc && mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DVVENC_ENABLE_WERROR=OFF && \
    cmake --build . --config Release -j $(nproc) && \
    cmake --install . && \
    echo '/usr/local/lib' > /etc/ld.so.conf.d/vvenc.conf && ldconfig
