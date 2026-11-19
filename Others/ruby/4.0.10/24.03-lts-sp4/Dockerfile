ARG BASE=openeuler/openeuler:24.03-lts-sp4
ARG VERSION=4.0.10

FROM ${BASE} AS builder
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION

RUN dnf install -y \
      gcc gcc-c++ make \
      bison \
      openssl-devel zlib-devel libffi-devel \
      readline-devel ncurses-devel libyaml-devel \
      gdbm-devel gmp-devel && \
    dnf clean all

RUN RUBY_SERIES=$(echo "${VERSION}" | cut -d. -f1,2) && \
    curl -fSL --connect-timeout 20 --retry 5 --retry-delay 5 \
      -o /tmp/ruby-${VERSION}.tar.gz \
      "https://cache.ruby-lang.org/pub/ruby/${RUBY_SERIES}/ruby-${VERSION}.tar.gz" && \
    echo "b53eef3371fa5d3e3b74340edcd015f06d5d8853968d4e539a5264fce41ed9f1  /tmp/ruby-${VERSION}.tar.gz" | sha256sum -c - && \
    tar -xzf /tmp/ruby-${VERSION}.tar.gz -C /tmp && \
    cd /tmp/ruby-${VERSION} && \
    ./configure --prefix=/usr/local --enable-shared --disable-install-doc && \
    make -j"$(nproc)" && \
    make install && \
    rm -rf /tmp/ruby-${VERSION} /tmp/ruby-${VERSION}.tar.gz

FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

COPY --from=builder /usr/local /usr/local

RUN ldconfig

USER root

CMD ["irb"]
