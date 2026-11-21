ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION=3.13.2.0

RUN yum install -y git gcc cmake g++ libtool pkgconfig autoconf automake \
        m4 libdnet-devel flex hwloc-devel libpcap-devel zlib-devel pcre2-devel \
        luajit-devel openssl-devel xz-devel && \
    yum clean all

RUN git clone -b v3.0.29 https://github.com/snort3/libdaq.git && \
    cd libdaq && \
    ./bootstrap && ./configure && \
    make -j $(nproc) && make install

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/usr/local/lib/daq
RUN git clone -b ${VERSION} https://github.com/snort3/snort3.git && \
    cd snort3 && \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig ./configure_cmake.sh --prefix=/usr/local && \
    cd build && \
    make -j $(nproc) install
