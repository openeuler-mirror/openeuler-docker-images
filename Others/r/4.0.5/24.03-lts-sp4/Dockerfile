ARG BASE=openeuler/openeuler:24.03-lts-sp4
ARG VERSION=4.0.5

FROM ${BASE} AS builder

ARG VERSION

RUN dnf install -y \
      gcc gcc-c++ gcc-gfortran make \
      diffutils findutils file perl \
      readline-devel pcre2-devel libcurl-devel \
      xz-devel bzip2-devel zlib-devel && \
    dnf clean all

RUN curl -fSL --connect-timeout 30 --retry 3 --retry-delay 5 \
      -o /tmp/R-${VERSION}.tar.gz \
      https://cran.r-project.org/src/base/R-4/R-${VERSION}.tar.gz && \
    tar -xzf /tmp/R-${VERSION}.tar.gz -C /tmp && \
    cd /tmp/R-${VERSION} && \
    sed -i '/#if LIBCURL_VERSION_MAJOR > 7/{n;s/  exit(1);/  exit(0);/}' configure && \
    ./configure --with-x=no --prefix=/usr/local && \
    make -j"$(nproc)" && \
    make install && \
    rm -rf /tmp/R-${VERSION} /tmp/R-${VERSION}.tar.gz

FROM ${BASE}

RUN dnf install -y \
      readline libcurl pcre2 xz-libs bzip2-libs zlib \
      libgfortran libquadmath libgomp libstdc++ libgcc && \
    dnf clean all

COPY --from=builder /usr/local /usr/local

USER root

CMD ["R"]
