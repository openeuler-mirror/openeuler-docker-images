ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
ARG FVCOM_COMMIT=3f27afed537de0eb2ab15feb5479eb8789cfd1dc
ARG NETCDF_FORTRAN_VERSION=4.6.1

RUN dnf install -y \
        gcc gcc-c++ gcc-gfortran make cmake git wget \
        mpich mpich-devel \
        netcdf-mpich-devel hdf5-mpich-devel \
        metis-devel zlib-devel curl-devel m4 && \
    dnf clean all && rm -rf /var/cache/dnf

ENV PATH=/usr/lib64/mpich/bin:${PATH}

RUN curl -L https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v${NETCDF_FORTRAN_VERSION}.tar.gz | tar xz && \
    cd netcdf-fortran-${NETCDF_FORTRAN_VERSION} && \
    mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr \
          -DCMAKE_Fortran_COMPILER=mpif90 \
          -DCMAKE_C_COMPILER=mpicc \
          -DCMAKE_LIBRARY_PATH=$(/usr/lib64/mpich/bin/nc-config --libdir) \
          -DCMAKE_INCLUDE_PATH=$(/usr/lib64/mpich/bin/nc-config --includedir) \
          -DENABLE_PARALLEL_TESTS=OFF \
          -DnetCDF_DIR=/usr/lib64/mpich .. && \
    make -j$(nproc) && make install && \
    cd / && rm -rf netcdf-fortran-${NETCDF_FORTRAN_VERSION}

RUN git init /fvcom && cd /fvcom && \
    git remote add origin https://github.com/FVCOM-GitHub/FVCOM.git && \
    git fetch --depth 1 origin ${FVCOM_COMMIT} && \
    git checkout FETCH_HEAD

WORKDIR /fvcom/src

RUN printf '%s\n' \
        'TOPDIR     = /fvcom/src' \
        'INSTALLDIR = /usr/local' \
        'CPP        = /usr/bin/cpp' \
        'COMPFLAG   = -DGFORTRAN' \
        'CC         = mpicc' \
        'CXX        = mpicxx' \
        'CFLAGS     = -O3' \
        'FC         = mpif90' \
        'OPT        = -O3' \
        'CLIB       =' \
        'VISOPT     =' \
        'LDFLAGS    =' \
        >> make.inc

ENV LIBPATH=/usr/lib64/mpich/lib:/usr/local/lib:/usr/lib64
ENV INCLUDEPATH=/usr/lib64/mpich/include:/usr/local/include:/usr/include

RUN sed -i \
        -e 's|^ *IOLIBS       =  -lnetcdff -lnetcdf #.*|IOLIBS       =  -lnetcdff -lnetcdf -lhdf5_hl -lhdf5 -lz -lcurl -lm|' \
        -e 's|^# *PARTINCS = .*|PARTINCS = -I/usr/include/metis|' \
        -e 's|^# *PARTLIBS = .*|PARTLIBS = -L/usr/lib64 -lmetis|' \
        make.inc && \
    printf 'COBJS = func_pointer.c partition.c\npartition.o: partition.c\n\t$(CC) $(CFLAGS) $(INCS) -c partition.c -o partition.o\n' >> makefile

RUN mkdir -p /usr/local/include /usr/local/lib /usr/local/bin && \
    cd /fvcom/libs && tar xzf julian.tgz && cd julian && make install

RUN make partition.o && make && \
    cp /fvcom/src/fvcom /usr/local/bin/fvcom && \
    cd / && rm -rf /fvcom

WORKDIR /workspace
CMD ["/bin/bash"]
