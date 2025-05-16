ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=4.7.0
ARG TARGETARCH
RUN yum install -y git gcc g++ glibc time tcsh jasper wget gfortran libcurl-devel m4 zlib-devel

WORKDIR /tmp/sources

# Install all dependecy
ENV HDF5=/usr/local
ENV NETCDF=/usr/local
ENV JASPERINC=/usr/include/jasper
ENV JASPERLIB=/usr/lib64/

RUN wget -O mpich-3.3.2.tar.gz http://www.mpich.org/static/downloads/3.3.2/mpich-3.3.2.tar.gz && \
    tar zxf mpich-3.3.2.tar.gz && \
    cd mpich-3.3.2 && \
    ./configure \
        --prefix=/usr/local \
        FFLAGS="-w -fallow-argument-mismatch -O2" && \
    make -j "$(nproc)" install

RUN wget -O hdf5-1.12.0.tar.gz https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.0/src/hdf5-1.12.0.tar.gz && \
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
        --enable-fortran \
        --enable-parallel \
        CC=mpicc FC=mpif90 CXX=mpicxx && \
    make -j "$(nproc)" install

RUN wget -O netcdf-c.tar.gz https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.7.4.tar.gz && \
    mkdir -p netcdf-c && tar vxf netcdf-c.tar.gz -C netcdf-c --strip-components=1 && \
    cd netcdf-c && \
    ./configure \
        --prefix=$NETCDF \
        LDFLAGS="-L$HDF5/lib" CPPFLAGS="-I$HDF5/include" CC=mpicc --disable-dap FC=mpif90 CXX=mpicxx && \
    make -j "$(nproc)" install && \
    ldconfig
RUN wget -O netcdf-fortran.tar.gz https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.5.3.tar.gz && \
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
RUN git clone -b v${VERSION} --recursive https://github.com/wrf-model/WRF.git /WRF && \
    if [ "$TARGETARCH" = "amd64" ]; then \
        ./configure <<< $'34\r1\r' ; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        ./configure <<< $'4\r1\r'; \
    fi; \
    ./compile -j "$(nproc)" em_real
