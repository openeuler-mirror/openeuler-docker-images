ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
ARG VERSION=5.0.0

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV LD_LIBRARY_PATH=/usr/local/lib

RUN dnf install -y cmake gcc-c++ make git wget \
    openmpi openmpi-devel \
    boost-devel \
    fftw fftw-devel gsl-devel \
    hdf5-devel python3-devel python3-pip \
    && dnf clean all \
    && rm -rf /var/cache/dnf

ENV PATH=/usr/lib64/openmpi/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/lib64/openmpi/lib:$LD_LIBRARY_PATH

RUN pip3 install --no-cache-dir \
    cython numpy scipy packaging setuptools h5py

WORKDIR /opt

RUN wget -O boost_1_83_0.tar.gz https://sourceforge.net/projects/boost/files/boost/1.83.0/boost_1_83_0.tar.gz/download \
    && tar -xzf boost_1_83_0.tar.gz \
    && rm boost_1_83_0.tar.gz \
    && cd boost_1_83_0 \
    && printf 'using gcc ;\nusing mpi ;\n' > user-config.jam \
    && ./bootstrap.sh --with-libraries=mpi,serialization,filesystem,system \
    && ./b2 -j$(nproc) \
        --prefix=/usr/local/boost-1.83.0 \
        --user-config=user-config.jam \
        variant=release \
        link=shared \
        threading=multi \
        install \
    && cd /opt \
    && rm -rf boost_1_83_0

ENV BOOST_ROOT=/usr/local/boost-1.83.0
ENV LD_LIBRARY_PATH=/usr/local/boost-1.83.0/lib:/usr/lib64/openmpi/lib:/usr/local/lib

RUN wget -O fftw-3.3.10.tar.gz http://www.fftw.org/fftw-3.3.10.tar.gz \
    && tar -xzf fftw-3.3.10.tar.gz \
    && rm fftw-3.3.10.tar.gz \
    && cd fftw-3.3.10 \
    && ./configure \
        --prefix=/usr/local/fftw-3.3.10 \
        --enable-mpi \
        --enable-shared \
    && make -j$(nproc) \
    && make install \
    && cd /opt \
    && rm -rf fftw-3.3.10

ENV FFTW_ROOT=/usr/local/fftw-3.3.10
ENV LD_LIBRARY_PATH=/usr/local/fftw-3.3.10/lib:/usr/local/boost-1.83.0/lib:/usr/lib64/openmpi/lib:/usr/local/lib

RUN git clone --depth 1 --branch ${VERSION} https://github.com/espressomd/espresso.git /opt/espresso-${VERSION}

WORKDIR /opt/espresso-${VERSION}

RUN mkdir build && cd build \
    && cmake .. \
        -D CMAKE_BUILD_TYPE=Release \
        -D ESPRESSO_BUILD_WITH_CUDA=OFF \
        -D ESPRESSO_BUILD_WITH_PYTHON=ON \
        -D ESPRESSO_BUILD_WITH_FFTW=ON \
        -D FFTW_INCLUDE_DIR=/usr/local/fftw-3.3.10/include \
        -D FFTW_LIBRARY=/usr/local/fftw-3.3.10/lib/libfftw3.so \
        -D FFTW_MPI_LIBRARY=/usr/local/fftw-3.3.10/lib/libfftw3_mpi.so \
        -D BOOST_ROOT=/usr/local/boost-1.83.0 \
    && make -j$(nproc)

ENV PATH=/opt/espresso-${VERSION}/build:$PATH

WORKDIR /opt/espresso-${VERSION}/build
CMD ["./pypresso"]