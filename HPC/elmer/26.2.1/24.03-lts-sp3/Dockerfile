ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE
ARG VERSION=26.2.1
ARG TAG=release-${VERSION}
RUN yum install -y \
        gcc gcc-c++ gcc-gfortran \
        openmpi-devel openblas-devel lapack-devel \
        cmake git make && \
    yum clean all && rm -rf /var/cache/yum
ENV PATH=/usr/lib64/openmpi/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/lib64/openmpi/lib
RUN git clone --branch ${TAG} --depth=1 https://github.com/ElmerCSC/elmerfem.git /elmer-src && \
    mkdir /elmer-src/builddir && \
    cd /elmer-src/builddir && \
    cmake /elmer-src \
        -DCMAKE_INSTALL_PREFIX=/opt/elmer \
        -DCMAKE_C_COMPILER=gcc \
        -DCMAKE_Fortran_COMPILER=gfortran \
        -DWITH_MPI:BOOL=TRUE \
        -DWITH_Mumps:BOOL=FALSE \
        -DWITH_Hypre:BOOL=FALSE \
        -DWITH_Trilinos:BOOL=FALSE \
        -DWITH_ELMERGUI:BOOL=FALSE \
        -DWITH_ElmerIce:BOOL=TRUE \
        -DWITH_LUA:BOOL=TRUE \
        -DWITH_OpenMP:BOOL=TRUE \
        -DWITH_UMFPACK:BOOL=TRUE \
        -DWITH_NETCDF:BOOL=FALSE && \
    make -j$(nproc) && \
    make install && \
    cd / && rm -rf /elmer-src
FROM $BASE
RUN yum install -y \
        openmpi openblas lapack libgomp && \
    yum clean all && rm -rf /var/cache/yum
ENV PATH=/usr/lib64/openmpi/bin:/opt/elmer/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/lib64/openmpi/lib:/opt/elmer/lib/elmersolver
COPY --from=0 /opt/elmer /opt/elmer
WORKDIR /workspace
CMD ["/bin/bash"]