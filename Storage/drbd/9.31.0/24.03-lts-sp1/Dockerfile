ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=9.31.0

RUN dnf install -y gcc-c++ make flex bison elfutils-libelf-devel \
    kernel-devel kernel-headers perl wget git pkgconfig libxslt \
    docbook-style-xsl po4a rubygem-asciidoctor keyutils-libs-devel \
    udev libnl3-devel libyaml-devel autoconf automake libtool \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN git clone https://github.com/LINBIT/drbd-utils \
    && cd drbd-utils \
    && git checkout v${VERSION} \
    && ./autogen.sh \
    && ./configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc \
    && make -j \
    && make install \
    && cd .. \
    && rm -rf drbd-utils

CMD ["drbdadm", "--help"]