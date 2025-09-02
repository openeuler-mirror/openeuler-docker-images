ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=11.7.0

RUN dnf update -y \
    && dnf install -y gcc ninja-build meson libxml2-devel yajl-devel systemd-devel libcap-ng-devel libnl3-devel \
    wget xz libcurl-devel libssh2-devel gnutls-devel libxslt-devel pkgconf-pkg-config perl \
    glib2-devel libtirpc-devel libacl-devel audit-libs-devel libblkid-devel libbsd-devel device-mapper-devel  \
    fuse3-devel libpciaccess-devel libselinux-devel libiscsi-devel librados2-devel librbd-devel \
    libpcap-devel bash-completion dmidecode iproute iscsi-initiator-utils kmod openvswitch \
    python3-docutils python3-pytest python3-black python3-flake8 iproute-tc \
    && dnf clean all

WORKDIR /opt

RUN wget https://download.libvirt.org/libvirt-${VERSION}.tar.xz \
    && tar -xvf libvirt-${VERSION}.tar.xz \
    && rm -f libvirt-${VERSION}.tar.xz

WORKDIR /opt/libvirt-${VERSION}

RUN meson setup build --prefix=/usr/local \
    && ninja -C build \
    && ninja -C build install

CMD ["libvirtd", "--help"]