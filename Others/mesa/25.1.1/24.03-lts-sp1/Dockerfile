ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=25.1.1

RUN dnf update -y \
    && dnf install -y wget dnf-plugins-core xz python3-pyyaml \
    && dnf builddep -y mesa \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN wget https://archive.mesa3d.org/mesa-${VERSION}.tar.xz \
    && tar -xvf mesa-${VERSION}.tar.xz \
    && rm -f mesa-${VERSION}.tar.xz

WORKDIR /opt/mesa-${VERSION}

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