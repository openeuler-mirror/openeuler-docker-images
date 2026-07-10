ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE
ARG TAG=6.07.1
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
ENV NETCDF_INCDIR=/usr/include
ENV NETCDF_LIBDIR=/usr/lib64
ENV NF_CONFIG=/usr/bin/nf-config
ENV NC_CONFIG=/usr/bin/nc-config
RUN git clone -b ${TAG} --depth=1 https://github.com/NOAA-EMC/WW3.git /WW3
ENV WWATCH3_NETCDF=NC4
ENV NETCDF_CONFIG=/usr/bin/nc-config
ENV EXTRA_COMP_OPTIONS="-fallow-argument-mismatch -fallow-invalid-boz"
ENV EXTRA_LINK_OPTIONS="-fallow-argument-mismatch"
RUN cd /WW3/model && \
    ./bin/w3_setup /WW3/model -c Gnu -s NCEP_st4 -q && \
    echo "NC4" >> bin/switch && \
    ./bin/w3_make ww3_shel ww3_grid ww3_prep ww3_outf ww3_outp ww3_prnc ww3_ounf ww3_ounp && \
    cp exe/ww3_shel exe/ww3_grid exe/ww3_prep exe/ww3_outf exe/ww3_outp exe/ww3_prnc exe/ww3_ounf exe/ww3_ounp /usr/local/bin/ && \
    cd / && rm -rf /WW3
ENV PATH=/usr/local/bin:$PATH
WORKDIR /workspace
CMD ["/bin/bash"]