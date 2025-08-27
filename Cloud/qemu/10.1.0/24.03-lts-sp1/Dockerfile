ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=10.1.0

RUN dnf update -y \
    && dnf install -y wget fuse3-devel  daxctl-devel \
    keyutils-libs-devel liburing-devel libnfs-devel \
    libcurl-devel libudev-devel ncurses-devel xz \
    alsa-lib-devel jack-audio-connection-kit-devel \
    gcc-c++ make ninja-build meson pkgconfig glib2-devel \
    libfdt-devel pixman-devel zlib-devel flex bison \
    pulseaudio-libs-devel libaio-devel libcap-ng-devel \
    libiscsi-devel libattr-devel libselinux-devel \
    libseccomp-devel libusbx-devel libzstd-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN wget https://download.qemu.org/qemu-${VERSION}.tar.xz \
    && tar xvJf qemu-${VERSION}.tar.xz \
    && rm -f qemu-${VERSION}.tar.xz

WORKDIR /opt/qemu-${VERSION}

RUN ./configure \
    && make -j \
    && make install

CMD sh -c 'exec qemu-system-$(uname -m) --help'
