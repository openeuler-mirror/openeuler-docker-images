ARG BASE=openeuler/openeuler:24.03-lts-sp4
ARG VERSION=1.15.0

FROM ${BASE} AS builder

ARG VERSION

RUN dnf install -y \
      gcc gcc-c++ gcc-gfortran make \
      diffutils findutils file perl \
      readline-devel pcre2-devel libcurl-devel \
      xz-devel bzip2-devel zlib-devel \
      pkg-config libuv-devel && \
    dnf clean all

RUN curl -fSL --connect-timeout 30 --retry 3 --retry-delay 5 \
      -o /tmp/R-4.4.3.tar.gz \
      https://cran.r-project.org/src/base/R-4/R-4.4.3.tar.gz && \
    tar -xzf /tmp/R-4.4.3.tar.gz -C /tmp && \
    cd /tmp/R-4.4.3 && \
    sed -i '/#if LIBCURL_VERSION_MAJOR > 7/{n;s/  exit(1);/  exit(0);/}' configure && \
    ./configure --with-x=no --prefix=/usr/local && \
    make -j"$(nproc)" && \
    make install && \
    rm -rf /tmp/R-4.4.3 /tmp/R-4.4.3.tar.gz

RUN curl -fSL --connect-timeout 30 --retry 3 --retry-delay 5 \
      -o /tmp/shiny.tar.gz \
      https://github.com/rstudio/shiny/archive/refs/tags/v${VERSION}.tar.gz && \
    Rscript -e 'options(repos = c(CRAN = "https://cloud.r-project.org/"), timeout = 600); install.packages("remotes", quiet = TRUE); remotes::install_local("/tmp/shiny.tar.gz", upgrade = "never")' && \
    rm -rf /tmp/shiny.tar.gz

FROM ${BASE}

RUN dnf install -y \
      readline libcurl pcre2 xz-libs bzip2-libs zlib \
      libgfortran libquadmath libgomp libstdc++ libgcc libuv && \
    dnf clean all

COPY --from=builder /usr/local /usr/local

USER root

CMD ["R"]
