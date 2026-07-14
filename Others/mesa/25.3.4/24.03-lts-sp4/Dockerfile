 ARG BASE=openeuler/openeuler:24.03-lts-sp4
 FROM ${BASE}
 ARG VERSION=25.3.4
 
 RUN dnf update -y \
     && dnf install -y wget dnf-plugins-core xz python3-pyyaml python3-pip  \
     gcc-c++ cmake libglvnd-devel mesa-libGLU-devel libdrm-devel llvm-devel clang-devel  \
     mesa-libGLU-devel pkgconfig libdrm-devel libudev-devel bison byacc  \
      spirv-tools lua-devel wayland-devel wayland-protocols-devel elfutils-libelf-devel flex  \
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

RUN sed -i '/^source_hash = /a source_fallback_url = https://github.com/mesonbuild/wrapdb/releases/download/wayland-protocols_1.41-1/wayland-protocols-1.41.tar.xz' subprojects/wayland-protocols.wrap \
    && mkdir build \
    && meson setup build  \
     -Dcpp_std=gnu++17 \
     -Dandroid-libbacktrace=disabled \
     -Dlibunwind=disabled \
     -Dlmsensors=disabled \
     -Db_ndebug=true \
     -Dplatforms=x11,wayland \
     -Dgallium-drivers="softpipe,llvmpipe,virgl" \
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