ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=5.4.2

RUN dnf install -y \
    wget \
    gcc-c++ \
    boost-devel \
    cmake \
    pcre-devel \
    python3 \
    ragel \
    sqlite-devel \
    libpcap-devel \
    make \
    patch \
    util-linux \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

WORKDIR /opt

RUN wget https://github.com/intel/hyperscan/archive/refs/tags/v${VERSION}.tar.gz \
    && tar -zxvf v${VERSION}.tar.gz \
    && rm -f v${VERSION}.tar.gz

WORKDIR /opt/hyperscan-${VERSION}

COPY Fix-hyperscan-gcc10.patch /opt/hyperscan-${VERSION}/Fix-hyperscan-gcc10.patch
COPY hyperscan-aarch64-support.patch /opt/hyperscan-${VERSION}/hyperscan-aarch64-support.patch

RUN mv src/util/simd_utils.h src/util/simd_x86.h \
    && sed -i 's/SIMD_UTILS/SIMD_X86/' src/util/simd_x86.h \
    && sed -i 's/_mm_set_epi32/set32x4/' src/util/state_compress.c \
    && sed -i 's/_mm_set_epi64x/set64x2/' src/util/state_compress.c \
    && sed -i 's/_mm_srli_si128/rshiftbyte_m128/' src/util/state_compress.c

RUN patch -p1 < /opt/hyperscan-${VERSION}/hyperscan-aarch64-support.patch \
    && patch -p1 < /opt/hyperscan-${VERSION}/Fix-hyperscan-gcc10.patch

WORKDIR /opt/hyperscan-${VERSION}/build

RUN cmake -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_AND_SHARED=OFF .. \
    && make -j$(nproc) \
    && make install

CMD ["./bin/unit-hyperscan"]
