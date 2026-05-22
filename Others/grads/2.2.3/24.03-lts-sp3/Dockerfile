ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG GRADS_VERSION=2.2.3

RUN dnf install -y \
      gcc gcc-c++ make cmake autoconf automake libtool pkgconf-devel \
      readline-devel ncurses-devel \
      libX11-devel libXaw-devel libXrender-devel libXext-devel libXt-devel \
      zlib-devel libpng-devel libjpeg-turbo-devel \
      curl-devel libxml2-devel \
      cairo-devel pixman-devel fontconfig-devel freetype-devel \
      gd-devel jasper-devel \
      libgeotiff-devel libtiff-devel proj-devel \
      git && \
    dnf clean all

ENV GADDIR=/usr/local/lib/grads/data

RUN mkdir -p /tmp/build && \
    cd /tmp/build && \
    git clone --depth 1 --branch v${GRADS_VERSION} https://github.com/j-m-adams/GrADS.git . && \
    mkdir -p supplibs/lib supplibs/include && \
    autoreconf -fi && \
    CAIRO_CFLAGS="-I/usr/include/cairo -I/usr/include/freetype2" CAIRO_LIBS="-lcairo" ./configure --prefix=/usr/local && \
    make -j$(nproc) && \
    make install && \
    mkdir -p /usr/local/lib/grads/data && \
    cp -r data/* /usr/local/lib/grads/data/ && \
    cd / && rm -rf /tmp/build
