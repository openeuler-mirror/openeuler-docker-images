ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE
ARG TAG=roms-4.2
RUN yum install -y \
        gcc-gfortran gcc-c++ make cmake git \
        netcdf-devel hdf5-devel openmpi-devel \
        zlib-devel curl-devel m4 && \
    yum clean all && rm -rf /var/cache/yum
ENV NETCDF_FORTRAN_VERSION=4.6.1
RUN curl -L https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v${NETCDF_FORTRAN_VERSION}.tar.gz | tar xz && \
    cd netcdf-fortran-${NETCDF_FORTRAN_VERSION} && \
    mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr \
          -DENABLE_PARALLEL_TESTS=OFF .. && \
    make -j$(nproc) && make install && \
    cd / && rm -rf netcdf-fortran-${NETCDF_FORTRAN_VERSION}
RUN git clone -b ${TAG} --depth=1 https://github.com/myroms/roms.git /roms
ENV NETCDF_INCDIR=/usr/include
ENV NETCDF_LIBDIR=/usr/lib64
ENV NF_CONFIG=/usr/bin/nf-config
ENV NC_CONFIG=/usr/bin/nc-config
WORKDIR /roms/build
RUN cmake -DCMAKE_Fortran_COMPILER=gfortran \
          -DCMAKE_BUILD_TYPE=Release \
          -DROMS_APP=UPWELLING \
          -DMY_HEADER_DIR=/roms/ROMS/Include \
          -DROMS_EXECUTABLE=ON \
          -DLIBTYPE=STATIC \
          .. && \
    make -j$(nproc) && \
    cp romsS /usr/local/bin/roms && \
    cd / && rm -rf /roms
WORKDIR /workspace
CMD ["/bin/bash"]