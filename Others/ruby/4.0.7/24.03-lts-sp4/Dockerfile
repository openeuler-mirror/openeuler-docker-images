ARG BASE=openeuler/openeuler:24.03-lts-sp4
ARG VERSION=4.0.7

FROM ${BASE} AS builder

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
    echo "911ace20f90d068ca0e4dda6d0e4f0f81e52e52f2dd4f4004c721e253412e82d  /tmp/ruby-${VERSION}.tar.gz" | sha256sum -c - && \
    tar -xzf /tmp/ruby-${VERSION}.tar.gz -C /tmp && \
    cd /tmp/ruby-${VERSION} && \
    ./configure --prefix=/usr/local --enable-shared --disable-install-doc && \
    make -j"$(nproc)" && \
    make install && \
    rm -rf /tmp/ruby-${VERSION} /tmp/ruby-${VERSION}.tar.gz

FROM ${BASE}

COPY --from=builder /usr/local /usr/local

RUN ldconfig

USER root

CMD ["irb"]
