ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION=2610.0
ARG TARGETARCH

RUN yum install -y git cmake gcc g++ autoconf automake ninja-build clang clang-tools-extra \
    xcb-util-keysyms-devel xcb-util-image-devel xcb-util-renderutil-devel \
    xcb-util-wm-devel xcb-util-devel xcb-util-cursor-devel xcb-util-xrm-devel \
    libunwind-devel zstd-devel mesa-libGL-devel fontconfig-devel \
    libxkbcommon-devel libX11-devel libxkbcommon-x11-devel wayland-devel \
    xorg-x11-server-devel libatomic && \
    yum clean all

RUN git clone -b ${VERSION} https://github.com/o3de/o3de.git

COPY ./python-requirements.patch /o3de/
WORKDIR /o3de
RUN export CC=clang CXX=clang++ && \
    git apply python-requirements.patch && \
    python/get_python.sh && \
    mkdir -p /opt/o3de-packages && \
    cmake -B build/linux -S . -G "Ninja Multi-Config" \
        -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
        -DLY_3RDPARTY_PATH=/opt/o3de-packages && \
    if [ "$TARGETARCH" = "amd64" ]; then \
        cmake --build build/linux --target Editor --config release -j2; \
    fi;
