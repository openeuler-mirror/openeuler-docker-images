ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=1.3.3

RUN dnf install -y \
      gcc gcc-c++ make \
      zlib-devel \
      curl && \
    dnf clean all

RUN mkdir -p /tmp/rsem-build && \
    curl -fSL --connect-timeout 60 --retry 5 --retry-delay 5 \
      -o /tmp/rsem-${VERSION}.tar.gz \
      https://github.com/deweylab/RSEM/archive/refs/tags/v${VERSION}.tar.gz && \
    echo "90e784dd9df8346caa2a7e3ad2ad07649608a51df1c69bfb6e16f45e611a40dc  /tmp/rsem-${VERSION}.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/rsem-${VERSION}.tar.gz --strip-components=1 -C /tmp/rsem-build && \
    rm -f /tmp/rsem-${VERSION}.tar.gz

WORKDIR /tmp/rsem-build

RUN make -j$(nproc) && \
    make install

FROM ${BASE}

RUN dnf install -y \
      perl && \
    dnf clean all

COPY --from=builder /usr/local/bin /usr/local/bin

WORKDIR /data

CMD ["rsem-calculate-expression", "--help"]
