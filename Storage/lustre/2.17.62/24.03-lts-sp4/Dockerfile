ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION=2.17.62

RUN dnf install -y wget gcc make autoconf automake libtool flex bison \
    pciutils-devel kernel-devel kernel-headers elfutils-libelf-devel \
    numactl-devel libuuid-devel keyutils-libs keyutils-libs-devel \
    libnl3-devel libyaml-devel git \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN wget https://github.com/lustre/lustre-release/archive/refs/tags/${VERSION}.tar.gz \
    && tar -zxvf ${VERSION}.tar.gz \
    && cd lustre-release-${VERSION} \
    && ./autogen.sh \
    && ./configure \
    && make KCFLAGS="-Wno-error=unused-label" \
    && make install \
    && ldconfig \
    && cd .. \
    && rm -rf lustre-release-${VERSION} \
    && rm -rf ${VERSION}.tar.gz

CMD ["lfs", "--version"]
