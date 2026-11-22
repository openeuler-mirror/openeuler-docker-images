ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE

ARG VERSION=2610.0
ARG TARGETARCH

RUN yum install -y git cmake gcc g++ autoconf automake ninja-build clang clang-tools-extra \
    xcb-util-keysyms-devel xcb-util-image-devel xcb-util-renderutil-devel \
    xcb-util-wm-devel xcb-util-devel xcb-util-cursor-devel xcb-util-xrm-devel \
    libunwind-devel zstd-devel mesa-libGL-devel fontconfig-devel harfbuzz \
    libxkbcommon-devel libX11-devel libxkbcommon-x11-devel wayland-devel \
    xorg-x11-server-devel libatomic && \
    yum clean all

RUN git clone -b ${VERSION} https://github.com/o3de/o3de.git

WORKDIR /o3de
RUN export CC=clang CXX=clang++ && \
    sed -i 's|^\(.*7e94c425039cde14257288fd61dcfb01963e658efbc0ff54f5306b06054700f8\)$|\1 \\\n    --hash=sha256:38a9ef736c01fccdd6600705b09dc574584b89bea478200c5fbf112a6b0d5579|' python/requirements.txt && \
    sed -i '/a2c405445c79c3f5a124573a051062300936b0281fee57637e706453e452746c/a\    --hash=sha256:78618cdbccaa74d3f88d0ad6cb8ac3007f1a6fa5c6f19af64b55ca170bfa1edf \\' python/requirements.txt && \
    python/get_python.sh && \
    mkdir -p /opt/o3de-packages && \
    if [ "$TARGETARCH" = "arm64" ]; then \
        git diff -R 0fb5d654bd5e3e4edbe1517a7c081ddc3531fd52^ HEAD -- cmake/LYWrappers.cmake | git apply && \
        sed -i 's/3rdParty::pyside6/3rdParty::pyside2/g' Gems/QtForPython/Code/CMakeLists.txt && \
        sed -i 's/3rdParty::Qt::SvgWidgets/3rdParty::Qt::Svg/g' Code/Framework/AzQtComponents/CMakeLists.txt && \
        sed -i 's/3rdParty::Qt::OpenGLWidgets/3rdParty::Qt::OpenGL/g' Gems/EMotionFX/Code/CMakeLists.txt; \
    fi && \
    cmake -B build/linux -S . -G "Ninja Multi-Config" \
        -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
        -DLY_3RDPARTY_PATH=/opt/o3de-packages && \
    cmake --build build/linux --target Editor --config release -j8;
