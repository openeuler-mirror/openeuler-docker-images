ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} as BUILDER
ARG VERSION=4.4.6

RUN dnf update -y \
    && dnf install -y wget maven gcc-c++ cmake glib2-devel c-ares-devel libgcrypt-devel  \
    qt6-qtbase-devel qt6-qtdeclarative-devel qt6-qttools-devel  \
    qt6-qt5compat-devel speexdsp-devel xz flex \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN wget https://www.wireshark.org/download/src/wireshark-${VERSION}.tar.xz \
    && tar -xf wireshark-${VERSION}.tar.xz \
    && cd wireshark-${VERSION} \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make install

CMD ["/usr/local/bin/wireshark", "--help"]