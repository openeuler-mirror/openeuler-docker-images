ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} as BUILDER
ARG VERSION=4.6.5

RUN dnf update -y \
    && dnf install -y wget maven gcc-c++ cmake glib2-devel c-ares-devel libgcrypt-devel  \
    qt6-qtbase-devel qt6-qtdeclarative-devel qt6-qttools-devel  \
    qt6-qt5compat-devel speexdsp-devel xz flex libpcap-devel libcap \
    libxml2-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN wget https://www.wireshark.org/download/src/all-versions/wireshark-${VERSION}.tar.xz \
    && tar -xf wireshark-${VERSION}.tar.xz \
    && rm -f wireshark-${VERSION}.tar.xz \
    && cd wireshark-${VERSION} \
    && mkdir build \
    && cd build \
    && cmake .. -DBUILD_wireshark=OFF -DBUILD_tshark=ON -DENABLE_CAP=ON \
    && make install \
    && cd ../../ \
    && rm -rf wireshark-${VERSION}

RUN groupadd -r wireshark && useradd -r -g wireshark wireshark

RUN chgrp wireshark /usr/local/bin/dumpcap \
    && chmod 750 /usr/local/bin/dumpcap \
    && setcap cap_net_raw,cap_net_admin=eip /usr/local/bin/dumpcap

USER wireshark

CMD ["tshark", "--help"]