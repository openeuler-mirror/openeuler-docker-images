ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=10.8.3
ARG LIBXC_RELEASE=7.0.0
ARG NETCDF_FORTRAN_RELEASE=4.6.2

ENV PATH=/usr/lib64/openmpi/bin:$PATH

RUN dnf install -y \
      gcc gcc-c++ gcc-gfortran \
      make cmake autoconf automake m4 \
      python3-unversioned-command \
      findutils diffutils \
      openmpi-devel \
      openblas-devel \
      fftw-devel \
      hdf5-openmpi-devel \
      netcdf-openmpi-devel \
      curl ca-certificates && \
    dnf clean all && \
    rm -rf /var/cache/dnf

RUN curl -fSL --connect-timeout 30 --retry 3 --retry-delay 5 \
      -o /tmp/libxc-${LIBXC_RELEASE}.tar.gz \
      https://forge.abinit.org/libxc-${LIBXC_RELEASE}.tar.gz && \
    echo "bfed96a2fb2c1207a6a3672269a9c7f8  /tmp/libxc-${LIBXC_RELEASE}.tar.gz" | md5sum -c - && \
    mkdir -p /build/libxc && \
    tar -xzf /tmp/libxc-${LIBXC_RELEASE}.tar.gz -C /build/libxc --strip-components=1 && \
    rm -f /tmp/libxc-${LIBXC_RELEASE}.tar.gz && \
    cmake -S /build/libxc -B /build/libxc/build \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DBUILD_SHARED_LIBS=ON \
      -DENABLE_FORTRAN=OFF \
      -DBUILD_TESTING=OFF && \
    cmake --build /build/libxc/build -j$(nproc) && \
    cmake --install /build/libxc/build && \
    rm -rf /build/libxc

RUN curl -fSL --connect-timeout 30 --retry 3 --retry-delay 5 \
      -o /tmp/netcdf-fortran-${NETCDF_FORTRAN_RELEASE}.tar.gz \
      https://downloads.unidata.ucar.edu/netcdf-fortran/${NETCDF_FORTRAN_RELEASE}/netcdf-fortran-${NETCDF_FORTRAN_RELEASE}.tar.gz && \
    echo "0e46a1f42a888ca2ebdb51a9c8ff70b8  /tmp/netcdf-fortran-${NETCDF_FORTRAN_RELEASE}.tar.gz" | md5sum -c - && \
    mkdir -p /build/netcdf-fortran && \
    tar -xzf /tmp/netcdf-fortran-${NETCDF_FORTRAN_RELEASE}.tar.gz -C /build/netcdf-fortran --strip-components=1 && \
    rm -f /tmp/netcdf-fortran-${NETCDF_FORTRAN_RELEASE}.tar.gz && \
    cd /build/netcdf-fortran && \
    ./configure \
      --prefix=/usr/local \
      --disable-static --enable-shared \
      CC=mpicc FC=mpifort \
      CPPFLAGS="-I/usr/include/openmpi-x86_64" \
      LDFLAGS="-L/usr/lib64/openmpi/lib" && \
    make -j$(nproc) && \
    make install && \
    rm -rf /build/netcdf-fortran

RUN curl -fSL --connect-timeout 30 --retry 3 --retry-delay 5 \
      -o /tmp/abinit-${VERSION}.tar.gz \
      https://github.com/abinit/abinit/archive/refs/tags/${VERSION}.tar.gz && \
    mkdir -p /build/abinit && \
    tar -xzf /tmp/abinit-${VERSION}.tar.gz -C /build/abinit --strip-components=1 && \
    rm -f /tmp/abinit-${VERSION}.tar.gz

WORKDIR /build/abinit
RUN python3 ./config/scripts/makemake

RUN mkdir -p /build/abinit/build && \
    cd /build/abinit/build && \
    export CC=mpicc CXX=mpicxx FC=mpifort && \
    export CPPFLAGS="-I/usr/include/openmpi-x86_64" && \
    export LDFLAGS="-L/usr/lib64/openmpi/lib" && \
    export FCFLAGS="-O2 -ffree-line-length-none -fallow-argument-mismatch" && \
    export H5CC=h5pcc && \
    export NETCDF_CPPFLAGS="-I/usr/include/openmpi-x86_64" && \
    export NETCDF_LIBS="-L/usr/lib64/openmpi/lib -lnetcdf" && \
    ../configure \
      --prefix=/usr/local \
      --with-mpi=yes \
      --with-linalg-flavor=openblas \
      --with-fft-flavor=fftw3 \
      --with-libxc=/usr/local \
      --with-netcdf-fortran=/usr/local \
      --enable-netcdf-default=yes \
      FFTW3_LIBS="-lfftw3 -lfftw3f" \
      LINALG_LIBS="-lopenblas" && \
    make -j$(nproc) && \
    make install

FROM ${BASE}

RUN dnf install -y \
      libgfortran \
      openmpi openblas fftw \
      hdf5-openmpi netcdf-openmpi && \
    dnf clean all && \
    rm -rf /var/cache/dnf

COPY --from=builder /usr/local/ /usr/local/

ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64
ENV OMPI_ALLOW_RUN_AS_ROOT=1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

WORKDIR /workspace

USER root

CMD ["/bin/bash"]
