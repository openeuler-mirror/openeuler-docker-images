ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE

ARG VERSION=2409.2
ARG TARGETARCH

RUN yum install -y git cmake gcc g++ autoconf automake ninja-build \
    libunwind-devel zstd-devel mesa-libGL-devel fontconfig-devel \
    libxkbcommon-devel libX11-devel libxkbcommon-x11-devel \
    xorg-x11-server-devel libatomic && \
    yum clean all

RUN git clone -b ${VERSION} https://github.com/o3de/o3de.git

COPY ./GCC.patch /o3de/
WORKDIR /o3de
RUN git apply GCC.patch && \
    python/get_python.sh && \
    mkdir -p /opt/o3de-packages && \
    cmake -B build/linux -S . -G "Ninja Multi-Config" -DLY_3RDPARTY_PATH=/opt/o3de-packages && \
    if [ "$TARGETARCH" = "amd64" ]; then \
        cmake --build build/linux --target Editor --config release -j2; \
    fi;