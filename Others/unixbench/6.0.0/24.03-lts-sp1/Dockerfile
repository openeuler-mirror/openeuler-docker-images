ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} AS builder

ARG VERSION=6.0.0

RUN dnf update -y \
    && dnf install -y gcc make patch wget perl perl-Time-HiRes time systemd \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN wget https://github.com/kdlucas/byte-unixbench/archive/v${VERSION}.tar.gz -O unixbench-${VERSION}.tar.gz \
    && tar -zxvf unixbench-${VERSION}.tar.gz \
    && rm -f unixbench-${VERSION}.tar.gz

WORKDIR /opt/byte-unixbench-${VERSION}

COPY unixbench-add-HOWTO.patch ./unixbench-add-HOWTO.patch

RUN patch -p1 < unixbench-add-HOWTO.patch

RUN mkdir -p /opt/unixbench/{pgms,src,testdir} \
    && cd UnixBench \
    && cp -p src/* /opt/unixbench/src/ \
    && cp -p testdir/* /opt/unixbench/testdir/ \
    && cp -p README USAGE HOWTO Makefile /opt/unixbench/ \
    && cp -p Run /opt/unixbench/ \
    && cp -p pgms/gfx-x11 pgms/*.sh /opt/unixbench/pgms/ \
    && cp -p pgms/index.base pgms/unixbench.logo /opt/unixbench/pgms/ \
    && chmod 755 /opt/unixbench/Run /opt/unixbench/pgms/gfx-x11 /opt/unixbench/pgms/*.sh \
    && chmod 644 /opt/unixbench/README /opt/unixbench/USAGE /opt/unixbench/HOWTO /opt/unixbench/Makefile /opt/unixbench/pgms/index.base /opt/unixbench/pgms/unixbench.logo \
    && cd /opt/unixbench \
    && make -j$(nproc)


FROM ${BASE} AS final

RUN dnf install -y make gcc perl perl-Time-HiRes time systemd \
    && dnf clean all \
    && rm -rf /var/cache/dnf

COPY --from=builder /opt/unixbench /opt/unixbench

WORKDIR /opt/unixbench

CMD ["./Run", "dhry2reg"]
