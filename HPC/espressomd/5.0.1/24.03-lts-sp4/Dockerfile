ARG BASE=openeuler/openeuler:24.03-lts-sp4
ARG VERSION=5.0.1
FROM ${BASE} AS builder

ARG VERSION
ARG BOOST_VERSION=1.83.0

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN dnf install -y \
      cmake gcc gcc-c++ make patch \
      git curl wget which tar gzip ca-certificates \
      openmpi-devel \
      fftw-devel zlib-devel \
      python3-devel python3-pip python3-Cython python3-setuptools && \
    dnf clean all && \
    rm -rf /var/cache/dnf

RUN git config --system protocol.version 0

RUN pip3 install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple \
      numpy==1.26.4

WORKDIR /opt

RUN curl -fSL --connect-timeout 30 --retry 3 -o boost_1_83_0.tar.gz \
      https://archives.boost.io/release/${BOOST_VERSION}/source/boost_1_83_0.tar.gz && \
    echo "c0685b68dd44cc46574cce86c4e17c0f611b15e195be9848dfd0769a0a207628  boost_1_83_0.tar.gz" | sha256sum -c - && \
    tar -xzf boost_1_83_0.tar.gz && \
    rm boost_1_83_0.tar.gz && \
    cd boost_1_83_0 && \
    printf 'using gcc ;\nusing mpi ;\n' > user-config.jam && \
    ./bootstrap.sh --with-libraries=mpi,serialization --prefix=/opt/boost && \
    ./b2 -j"$(nproc)" --user-config=user-config.jam variant=release link=shared threading=multi install && \
    cd /opt && \
    rm -rf boost_1_83_0

RUN curl -fSL --connect-timeout 30 --retry 3 -o espresso-${VERSION}.tar.gz \
      https://github.com/espressomd/espresso/archive/refs/tags/${VERSION}.tar.gz && \
    tar -xzf espresso-${VERSION}.tar.gz && \
    rm espresso-${VERSION}.tar.gz

WORKDIR /opt/espresso-${VERSION}

RUN cmake -S . -B build \
      -D CMAKE_BUILD_TYPE=Release \
      -D CMAKE_INSTALL_PREFIX=/opt/espresso \
      -D CMAKE_PREFIX_PATH=/opt/boost \
      -D BOOST_ROOT=/opt/boost \
      -D ESPRESSO_BUILD_WITH_PYTHON=ON \
      -D ESPRESSO_BUILD_WITH_FFTW=ON \
      -D ESPRESSO_BUILD_WITH_CUDA=OFF \
      -D ESPRESSO_BUILD_WITH_HDF5=OFF \
      -D ESPRESSO_BUILD_WITH_GSL=OFF \
      -D ESPRESSO_BUILD_WITH_WALBERLA=OFF \
      -D ESPRESSO_BUILD_TESTS=OFF \
      -D ESPRESSO_INSIDE_DOCKER=ON && \
    cmake --build build -j"$(nproc)" && \
    cmake --install build

FROM ${BASE}

ARG VERSION

LABEL org.opencontainers.image.title="ESPResSo" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.description="Extensible Simulation Package for Research on Soft Matter" \
      org.opencontainers.image.licenses="GPL-3.0-or-later" \
      org.opencontainers.image.source="https://github.com/espressomd/espresso"

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV PATH=/opt/espresso/bin:$PATH
ENV LD_LIBRARY_PATH=/opt/boost/lib:/usr/lib64/openmpi/lib:$LD_LIBRARY_PATH

RUN dnf install -y \
      openmpi \
      fftw \
      python3-pip && \
    dnf clean all && \
    rm -rf /var/cache/dnf

RUN pip3 install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple \
      numpy==1.26.4 scipy==1.12.0

COPY --from=builder /opt/boost/lib /opt/boost/lib
COPY --from=builder /opt/espresso /opt/espresso

USER root

WORKDIR /opt/espresso

CMD ["pypresso"]
