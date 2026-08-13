ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=5.4.0-alpha04

RUN dnf install -y \
      gcc gcc-c++ make \
      flex bison \
      netcdf-devel hdf5-devel \
      antlr-C++ antlr-tool gsl-devel \
      curl-devel libxml2-devel expat-devel zlib-devel && \
    dnf clean all

RUN curl -fSL --connect-timeout 30 --retry 2 \
      -o /tmp/nco.tar.gz \
      https://github.com/nco/nco/archive/refs/tags/${VERSION}.tar.gz && \
    mkdir -p /tmp/nco-src && \
    tar xzf /tmp/nco.tar.gz -C /tmp/nco-src --strip-components=1 && \
    cd /tmp/nco-src && \
    ./configure --prefix=/usr/local --disable-udunits && \
    make -j$(nproc) && \
    make install && \
    cd / && \
    rm -rf /tmp/nco.tar.gz /tmp/nco-src

FROM ${BASE}

RUN dnf install -y \
      netcdf hdf5 \
      gsl antlr-C++ \
      libcurl libxml2 expat zlib \
      perl && \
    dnf clean all

COPY --from=builder /usr/local /usr/local

RUN printf '/usr/local/lib\n/usr/local/lib64\n' > /etc/ld.so.conf.d/nco.conf && \
    ldconfig

ENV PATH=/usr/local/bin:$PATH
USER root
WORKDIR /data
