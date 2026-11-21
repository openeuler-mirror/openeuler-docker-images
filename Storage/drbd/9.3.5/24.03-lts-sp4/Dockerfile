ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION=9.3.5

RUN dnf install -y gcc make diffutils patch perl kmod \
    kernel-devel kernel-headers elfutils-libelf-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

# DRBD 9 is a kernel module. The source is taken from LINBIT's release tarball:
# the archive GitHub generates for a tag carries neither the drbd-headers
# submodule nor the pre-generated kernel compat patches that the build needs.
# A container has no kernel of its own (uname -r reports the host kernel), so
# the module is built against the kernel-devel shipped with this openEuler
# release and KDIR is passed explicitly instead of /lib/modules/$(uname -r)/build.
RUN KDIR=$(ls -d /usr/src/kernels/*) \
    && curl -fsSL https://pkg.linbit.com/downloads/drbd/9/drbd-${VERSION}.tar.gz -o drbd-${VERSION}.tar.gz \
    && tar -xzf drbd-${VERSION}.tar.gz \
    && cd drbd-${VERSION} \
    && make KDIR=${KDIR} -j$(nproc) \
    && make KDIR=${KDIR} install \
    && cd .. \
    && rm -rf drbd-${VERSION} drbd-${VERSION}.tar.gz

CMD ["sh", "-c", "modinfo /lib/modules/*/updates/drbd.ko"]
