ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION=6.8.5

RUN dnf install -y git gcc-c++ cmake wget libselinux-devel \
    meson intltool python3-gobject-base desktop-file-utils vala \
    libxml2-devel libSM-devel libexif-devel libgsf-devel exempi-devel \
    gobject-introspection-devel libnotify-devel iso-codes-devel \
    gtk3-devel json-glib-devel xkeyboard-config-devel libgnomekbd-devel \
    pulseaudio-libs-devel xkeyboard-config-devel systemd-devel \
    libxkbfile-devel pygobject3-devel libdbusmenu-gtk3-devel \
    xorg-x11-server-Xvfb \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN git clone https://github.com/linuxmint/cinnamon-desktop.git \
    && cd cinnamon-desktop \
    && meson setup build \
    && ninja -C build \
    && ninja -C build install

RUN git clone https://github.com/linuxmint/xapp.git \
    && cd xapp \
    && meson setup build \
    && ninja -C build \
    && ninja -C build install

RUN wget https://github.com/linuxmint/nemo/archive/refs/tags/${VERSION}.tar.gz \
    && tar -zxvf ${VERSION}.tar.gz \
    && rm -f ${VERSION}.tar.gz


ENV PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH

WORKDIR /opt/nemo-${VERSION}

RUN meson setup build -Ddeprecated_warnings=false -Dgtk_doc=false -Dselinux=true -Dvideo_preview=false \
    && meson compile -C build \
    && meson install -C build

ENV LD_LIBRARY_PATH=/usr/local/lib64:$LD_LIBRARY_PATH

CMD ["nemo", "--help"]
