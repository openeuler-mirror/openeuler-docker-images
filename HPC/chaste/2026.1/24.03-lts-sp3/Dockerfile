ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE
ARG VERSION=2026.1
ARG PETSC_VERSION=3.20.6
ARG PETSC_ARCH=arch-linux-c-opt
RUN yum install -y \
        cmake gcc gcc-c++ gcc-gfortran make git which \
        openmpi-devel openblas-devel boost-devel fftw-devel \
        python3 python3-devel python3-pip python3-setuptools python3-wheel \
        && yum clean all && rm -rf /var/cache/yum
RUN MPI_CC=$(command -v mpicc 2>/dev/null || \
             find /usr -name mpicc -type f -print -quit 2>/dev/null || true) && \
    if [ -n "$MPI_CC" ]; then \
        MPI_BIN=$(dirname "$MPI_CC") && \
        MPI_ROOT=$(dirname "$MPI_BIN") && \
        MPI_LIB=$(find "$MPI_ROOT" -name libmpi.so -print -quit 2>/dev/null | xargs dirname) && \
        echo "MPI found: bin=$MPI_BIN root=$MPI_ROOT lib=$MPI_LIB" && \
        ln -sf "$MPI_BIN/mpicc" /usr/local/bin/mpicc && \
        ln -sf "$MPI_BIN/mpicxx" /usr/local/bin/mpicxx && \
        ln -sf "$MPI_BIN/mpif90" /usr/local/bin/mpif90 2>/dev/null || true && \
        echo "$MPI_ROOT" > /tmp/mpi_root.txt && \
        echo "$MPI_LIB" > /tmp/mpi_lib.txt && \
        MPI_CONF="--with-mpi-dir=$MPI_ROOT" ; \
    else \
        echo "MPI not found, using PETSc bundled MPICH" && \
        MPI_CONF="--download-mpich" ; \
    fi && \
    git clone -b v${PETSC_VERSION} --depth=1 \
        https://gitlab.com/petsc/petsc.git /opt/petsc && \
    cd /opt/petsc && \
    python3 configure \
        --PETSC_ARCH=${PETSC_ARCH} \
        $MPI_CONF \
        --download-f2cblaslapack \
        --download-metis \
        --download-parmetis \
        --download-hdf5 \
        --COPTFLAGS=-O2 \
        --CXXOPTFLAGS=-O2 \
        --FOPTFLAGS=-O2 && \
    make all -j$(nproc) && \
    rm -rf /opt/petsc/${PETSC_ARCH}/obj \
           /opt/petsc/${PETSC_ARCH}/externalpackages
ENV PETSC_DIR=/opt/petsc \
    PETSC_ARCH=${PETSC_ARCH} \
    HDF5_ROOT=/opt/petsc/${PETSC_ARCH} \
    ParMETIS_ROOT=/opt/petsc/${PETSC_ARCH}
RUN yum install -y xerces-c-devel curl && yum clean all && rm -rf /var/cache/yum && \
    curl -L -o /tmp/xsd.tar.bz2 \
        https://www.codesynthesis.com/download/xsd/4.0/xsd-4.0.0+dep.tar.bz2 && \
    tar xjf /tmp/xsd.tar.bz2 -C /tmp/ && \
    XSD_DIR=$(find /tmp -path "*/libxsd/xsd" -type d | head -1) && \
    cp -r "$XSD_DIR" /usr/include/ && \
    rm -rf /tmp/xsd.tar.bz2 /tmp/xsd-*
RUN MPI_LIB=$(cat /tmp/mpi_lib.txt 2>/dev/null || true) && \
    rm -f /tmp/mpi_root.txt /tmp/mpi_lib.txt && \
    if [ -n "$MPI_LIB" ]; then \
        echo "$MPI_LIB" > /etc/ld.so.conf.d/openmpi.conf && \
        ldconfig ; \
    fi && \
    git clone -b ${VERSION} --depth=1 \
        https://github.com/Chaste/Chaste.git /opt/chaste && \
    sed -i 's/lung heart)/lung)/' /opt/chaste/CMakeLists.txt && \
    sed -i 's/ COMPONENTS heart//' /opt/chaste/apps/CMakeLists.txt && \
    sed -i 's/find_package (XSD REQUIRED)/find_package (XSD)/' /opt/chaste/CMakeLists.txt && \
    sed -i '/add_subdirectory (apps)/d' /opt/chaste/CMakeLists.txt && \
    mkdir -p /opt/chaste/build && \
    cd /opt/chaste/build && \
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DChaste_ERROR_ON_WARNING=OFF \
        -DChaste_UPDATE_PROVENANCE=OFF \
        -DChaste_USE_VTK=OFF \
        -DChaste_USE_XERCES=ON \
        -DChaste_USE_CVODE=OFF \
        -DChaste_ENABLE_TESTING=OFF \
        .. && \
    make -j$(nproc)
WORKDIR /workspace
CMD ["/bin/bash"]