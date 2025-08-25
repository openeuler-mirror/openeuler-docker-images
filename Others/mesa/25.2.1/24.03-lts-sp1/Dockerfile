ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=25.2.1

RUN dnf update -y \
    && dnf install -y wget dnf-plugins-core xz python3-pyyaml python3-pip  \
    gcc-c++ cmake libglvnd-devel mesa-libGLU-devel libdrm-devel llvm-devel clang-devel  \
    mesa-libGLU-devel pkgconfig libdrm-devel libudev-devel bison byacc  \
    spirv-tools lua-devel wayland-devel elfutils-libelf-devel flex  \
    libXext-devel libX11-devel libxshmfence-devel  \
    libXxf86vm-devel libXrandr-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN wget https://archive.mesa3d.org/mesa-${VERSION}.tar.xz \
    && tar -xvf mesa-${VERSION}.tar.xz \
    && rm -f mesa-${VERSION}.tar.xz

WORKDIR /opt/mesa-${VERSION}

RUN pip3 install --upgrade pip \
    && pip3 install meson ninja mako

RUN mkdir build \
    && meson setup build  \
    -Dcpp_std=gnu++17 \
    -Dandroid-libbacktrace=disabled \
    -Dlibunwind=disabled \
    -Dlmsensors=disabled \
    -Db_ndebug=true \
    -Dplatforms=x11,wayland \
    -Dgallium-drivers="softpipe,llvmpipe,virgl" \
    -Dgallium-vdpau=disabled \
    -Dgallium-va=disabled \
    -Dvulkan-drivers= \
    -Dvulkan-layers=device-select \
    -Dgles1=disabled \
    -Dgles2=enabled \
    -Dopengl=true \
    -Dgbm=enabled \
    -Dvideo-codecs=all_free \
    -Dglx=dri \
    -Degl=enabled \
    -Dglvnd=enabled \
    -Dintel-rt=disabled \
    -Dllvm-orcjit=true \
    -Dmicrosoft-clc=disabled \
    -Dllvm=enabled \
    -Dshared-llvm=enabled \
    -Dvalgrind=disabled \
    -Dbuild-tests=false \
    && meson compile -C build \
    && meson install -C build

CMD ["bash"]
