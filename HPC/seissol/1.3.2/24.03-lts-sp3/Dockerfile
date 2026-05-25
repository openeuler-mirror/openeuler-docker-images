ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE} AS builder

ARG TARGETARCH
ARG EASI_VERSION=1.6.2
ARG EIGEN_VERSION=3.4.0
ARG SEISSOL_VERSION=1.3.2

RUN dnf install -y \
      gcc gcc-c++ gcc-gfortran make cmake git \
      openmpi-devel hdf5-openmpi-devel netcdf-openmpi-devel \
      lua-devel yaml-cpp-devel numactl-devel \
      python3-pip python3-numpy && \
    dnf clean all

RUN curl -fSL -o eigen.tar.bz2 https://gitlab.com/libeigen/eigen/-/archive/${EIGEN_VERSION}/eigen-${EIGEN_VERSION}.tar.bz2 && \
    mkdir -p /tmp/eigen && tar -jxf eigen.tar.bz2 -C /tmp/eigen --strip-components=1 && rm -f eigen.tar.bz2 && \
    cd /tmp/eigen && \
    cmake -B build \
      -DCMAKE_INSTALL_PREFIX=/usr/local && \
    cmake --install build && \
    rm -rf /tmp/eigen

RUN git clone --depth 1 --branch v${EASI_VERSION} https://github.com/SeisSol/easi.git /tmp/easi && \
    cd /tmp/easi && \
    cmake -B build \
      -DCMAKE_BUILD_TYPE=Release \
      -DASAGI=OFF \
      -DBUILD_SHARED_LIBS=ON \
      -DLUA=ON \
      -DTESTING=OFF \
      -DEASICUBE=OFF \
      -DPYTHON_BINDINGS=OFF \
      -DCMAKE_INSTALL_PREFIX=/usr/local && \
    cmake --build build --parallel $(nproc) && \
    cmake --install build && \
    rm -rf /tmp/easi

RUN git clone --depth 1 https://github.com/KarypisLab/GKlib.git /tmp/gklib && \
    cd /tmp/gklib && \
    make config cc=mpicc prefix=/usr/local && \
    make -j $(nproc) && \
    make install && \
    rm -rf /tmp/gklib

RUN git clone --depth 1 --branch v5.2.1 https://github.com/KarypisLab/METIS.git /tmp/metis && \
    cd /tmp/metis && \
    make config shared=1 cc=mpicc prefix=/usr/local gklib_path=/usr/local && \
    make -j $(nproc) && \
    make install && \
    rm -rf /tmp/metis

RUN git clone --depth 1 https://github.com/KarypisLab/ParMETIS.git /tmp/parmetis && \
    cd /tmp/parmetis && \
    make config shared=1 cc=mpicc cxx=mpicxx prefix=/usr/local metis_path=/usr/local gklib_path=/usr/local && \
    make -j $(nproc) && \
    make install && \
    rm -rf /tmp/parmetis

RUN git clone --recursive --depth 1 --branch v${SEISSOL_VERSION} https://github.com/SeisSol/SeisSol.git /tmp/seissol && \
    cd /tmp/seissol && \
    cmake -B build \
      -DCMAKE_BUILD_TYPE=Release \
      -DHOST_ARCH=noarch \
      -DORDER=4 \
      -DEQUATIONS=elastic \
      -DPRECISION=double \
      -DDEVICE_BACKEND=none \
      -DGEMM_TOOLS_LIST=Eigen \
      -DGKLIB_TEST_RUNS=ON \
      -DMETIS_TEST_RUNS=ON \
      -D_METIS_64_BIT_INTEGER=ON \
      -DPARMETIS_TEST_RUNS=ON \
      -DCMAKE_PREFIX_PATH="/usr/local" \
      -DHDF5_ROOT=/usr/lib64/openmpi \
      -DCMAKE_INSTALL_PREFIX=/usr/local && \
    cmake --build build --parallel $(nproc) && \
    cmake --install build && \
    ln -sf /usr/local/bin/SeisSol_Release_*_4_elastic /usr/local/bin/SeisSol && \
    rm -rf /tmp/seissol

FROM ${BASE}

RUN dnf install -y \
      openmpi hdf5-openmpi netcdf-openmpi \
      lua yaml-cpp numactl && \
    dnf clean all

COPY --from=builder /usr/local/bin/SeisSol* /usr/local/bin/
COPY --from=builder /usr/local/lib64 /usr/local/lib64
COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /usr/local/include /usr/local/include

RUN ldconfig

ENV PATH=/usr/lib64/openmpi/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/lib64/openmpi/lib:/usr/local/lib64:/usr/local/lib:$LD_LIBRARY_PATH

WORKDIR /data
CMD ["mpirun", "--allow-run-as-root", "/usr/local/bin/SeisSol"]
