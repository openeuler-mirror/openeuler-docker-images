ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=1.4.0

RUN dnf install -y \
      git gcc gcc-c++ gcc-gfortran make cmake \
      openmpi openmpi-devel \
      zlib-devel libpng-devel libjpeg-turbo-devel \
      jasper-devel hdf5-devel netcdf-devel && \
    dnf clean all

ENV PATH=/usr/lib64/openmpi/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/lib64/openmpi/lib:$LD_LIBRARY_PATH

ARG NETCDF_FORTRAN_VERSION=4.6.1
RUN git clone --branch v${NETCDF_FORTRAN_VERSION} https://github.com/Unidata/netcdf-fortran.git /tmp/netcdf-fortran && \
    mkdir -p /tmp/netcdf-fortran/build && cd /tmp/netcdf-fortran/build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make -j$(nproc) && make install && \
    rm -rf /tmp/netcdf-fortran

RUN git clone --branch v${VERSION} --recursive https://github.com/NOAA-EMC/NCEPLIBS.git /tmp/NCEPLIBS && \
    sed -i 's/ wgrib2//' /tmp/NCEPLIBS/CMakeLists.txt && \
    mkdir -p /tmp/NCEPLIBS/build && cd /tmp/NCEPLIBS/build && \
    cmake -DCMAKE_INSTALL_PREFIX=/opt/nceplibs \
          -DCMAKE_C_COMPILER=gcc \
          -DCMAKE_CXX_COMPILER=g++ \
          -DCMAKE_Fortran_COMPILER=gfortran \
          -DBUILD_TESTING=OFF \
          -DNetCDF_ROOT=/usr .. && \
    make -j$(nproc) || true && \
    rm -rf /tmp/NCEPLIBS

ENV LD_LIBRARY_PATH=/opt/nceplibs/lib:$LD_LIBRARY_PATH
ENV CMAKE_PREFIX_PATH=/opt/nceplibs
