ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG VERSION=fbf1aec

RUN dnf install -y \
      git gcc gcc-c++ make \
      autoconf automake libtool \
      hdf5-devel netcdf-devel \
      libX11-devel libXaw-devel libXt-devel libpng-devel && \
    dnf clean all

RUN curl -fSL -o /tmp/liblo.tar.gz https://github.com/radarsat1/liblo/releases/download/0.32/liblo-0.32.tar.gz && \
    cd /tmp && tar xzf liblo.tar.gz && \
    cd liblo-0.32 && \
    ./configure --prefix=/usr/local && make -j $(nproc) && make install && \
    rm -rf /tmp/liblo*

RUN git clone https://github.com/iem-projects/ncview.git && \
    cd ncview && \
    git checkout ${VERSION} && \
    aclocal -I m4macros && autoconf && autoheader && automake -a && \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig ./configure --prefix=/usr/local && \
    make -j $(nproc) && \
    make install
