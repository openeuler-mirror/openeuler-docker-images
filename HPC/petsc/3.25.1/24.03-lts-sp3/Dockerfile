ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE
ARG VERSION=3.25.1
ARG TAG=v${VERSION}
RUN yum install -y \
        gcc gcc-c++ gcc-gfortran \
        make git python3 \
        openmpi-devel && \
    yum clean all && rm -rf /var/cache/yum
ENV PATH=/usr/lib64/openmpi/bin:$PATH
RUN git clone -b ${TAG} https://github.com/petsc/petsc.git /petsc && \
    cd /petsc && \
    ./configure \
        --prefix=/usr/local/petsc \
        --with-cc=mpicc --with-cxx=mpicxx --with-fc=mpif90 \
        --download-fblaslapack \
        --with-debugging=0 \
        --COPTFLAGS="-O2" --CXXOPTFLAGS="-O2" --FOPTFLAGS="-O2" && \
    make -j 4 all && \
    make install && \
    rm -rf /petsc
ENV PETSC_DIR=/usr/local/petsc
WORKDIR /workspace
CMD ["/bin/bash"]