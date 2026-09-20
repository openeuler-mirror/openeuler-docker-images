ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=4.7.0
ARG WRF_VERSION=4.8.0
ARG TARGETARCH

RUN dnf install -y \
      git gcc gcc-c++ gcc-gfortran make cmake m4 patch \
      wget time tcsh \
      zlib-devel libpng-devel libjpeg-turbo-devel \
      libcurl-devel glibc && \
    dnf clean all

WORKDIR /tmp/sources

RUN wget --timeout=60 --tries=3 https://github.com/jasper-software/jasper/releases/download/version-2.0.33/jasper-2.0.33.tar.gz && \
    tar -xzf jasper-2.0.33.tar.gz && \
    rm -f jasper-2.0.33.tar.gz && \
    cd jasper-2.0.33/build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local && \
    make -j "$(nproc)" && \
    make install

ENV HDF5=/usr/local
ENV NETCDF=/usr/local
ENV JASPERINC=/usr/local/include
ENV JASPERLIB=/usr/local/lib64
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64

RUN wget --timeout=60 --tries=3 -O mpich-3.3.2.tar.gz http://www.mpich.org/static/downloads/3.3.2/mpich-3.3.2.tar.gz && \
    tar zxf mpich-3.3.2.tar.gz && \
    cd mpich-3.3.2 && \
    ./configure \
        --prefix=/usr/local \
        FFLAGS="-w -fallow-argument-mismatch -O2" && \
    make -j "$(nproc)" install

RUN wget --timeout=60 --tries=3 -O hdf5-1.12.0.tar.gz https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.0/src/hdf5-1.12.0.tar.gz && \
    tar zxf hdf5-1.12.0.tar.gz && \
    cd hdf5-1.12.0 && \
    ./configure \
        --prefix=$HDF5 \
        --enable-fortran \
        --enable-static=yes \
        --enable-parallel \
        --enable-shared \
        CFLAGS="-O3 -fPIC -Wno-incompatible-pointer-types-discards-qualifiers -Wno-non-literal-null-conversion" \
        FCFLAGS="-O3 -fPIC" LDFLAGS="-Wl,--build-id" \
        CC=mpicc FC=mpif90 CXX=mpicxx && \
    make -j "$(nproc)" install

RUN wget --timeout=60 --tries=3 -O netcdf-c.tar.gz https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.7.4.tar.gz && \
    mkdir -p netcdf-c && tar vxf netcdf-c.tar.gz -C netcdf-c --strip-components=1 && \
    cd netcdf-c && \
    ./configure \
        --prefix=$NETCDF \
        LDFLAGS="-L$HDF5/lib" CPPFLAGS="-I$HDF5/include" CC=mpicc --disable-dap FC=mpif90 CXX=mpicxx && \
    make -j "$(nproc)" install && \
    ldconfig

RUN wget --timeout=60 --tries=3 -O netcdf-fortran.tar.gz https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.5.3.tar.gz && \
    mkdir netcdf-fortran && tar -zvxf netcdf-fortran.tar.gz -C netcdf-fortran --strip-components=1 && \
    cd netcdf-fortran && \
    ./configure \
        --prefix=$NETCDF \
        CPPFLAGS="-I$HDF5/include -I$NETCDF/include" \
        LDFLAGS="-L$HDF5/lib -L$NETCDF/lib" \
        --enable-static=yes \
        --enable-shared \
        CFLAGS="-O3 -fPIC -Wno-incompatible-pointer-types-discards-qualifiers -Wno-non-literal-conversion" \
        FCFLAGS="-O3 -fPIC" LDFLAGS="-Wl,--build-id" \
        CC=mpicc FC=mpif90 CXX=mpicxx && \
    make -j "$(nproc)" install && \
    ldconfig && \
    rm -rf /tmp/sources

WORKDIR /WRF
RUN git clone -b v${WRF_VERSION} --recursive https://github.com/wrf-model/WRF.git /WRF && \
    if [ "$TARGETARCH" = "amd64" ]; then \
        ./configure <<< $'34\r1\r' ; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        ./configure <<< $'4\r1\r'; \
    fi; \
    ./compile -j "$(nproc)" em_real

WORKDIR /WPS
RUN wget --timeout=60 --tries=3 -O WPS.tar.gz https://github.com/wrf-model/WPS/archive/refs/tags/v${VERSION}.tar.gz && \
    tar -zxvf WPS.tar.gz -C /WPS --strip-components=1 && \
    rm -f WPS.tar.gz

COPY aarch64.patch /WPS/

RUN patch -Np1 < aarch64.patch && \
    ./configure <<< $'1\r' && \
    ./compile

FROM ${BASE}

RUN dnf install -y \
      libgfortran libgomp libjpeg-turbo && \
    dnf clean all

COPY --from=builder /usr/local /usr/local
COPY --from=builder /WPS /WPS

ENV NETCDF=/usr/local
ENV JASPERINC=/usr/local/include
ENV JASPERLIB=/usr/local/lib64
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64

RUN printf "/usr/local/lib\n/usr/local/lib64\n" > /etc/ld.so.conf.d/wps-local.conf && \
    ldconfig

WORKDIR /WPS
USER root
