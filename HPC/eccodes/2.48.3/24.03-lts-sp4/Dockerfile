ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE AS builder

ARG VERSION=2.48.3
ARG LIBAEC_VERSION=1.1.4

RUN dnf install -y \
      gcc gcc-c++ gcc-gfortran make cmake \
      git ca-certificates \
      netcdf-devel \
      openjpeg2-devel && \
    dnf clean all

RUN curl -fSL --connect-timeout 30 --retry 3 --retry-delay 5 \
      -o /tmp/libaec.tar.gz \
      https://github.com/Deutsches-Klimarechenzentrum/libaec/archive/refs/tags/v${LIBAEC_VERSION}.tar.gz && \
    mkdir -p /build/libaec && \
    tar -xzf /tmp/libaec.tar.gz -C /build/libaec --strip-components=1 && \
    rm -f /tmp/libaec.tar.gz && \
    cmake -S /build/libaec -B /build/libaec/build \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/opt/libaec \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DBUILD_TESTING=OFF && \
    cmake --build /build/libaec/build -j$(nproc) && \
    cmake --install /build/libaec/build && \
    rm -rf /build/libaec

RUN curl -fSL --connect-timeout 30 --retry 3 --retry-delay 5 \
      -o /tmp/eccodes.tar.gz \
      https://github.com/ecmwf/eccodes/archive/refs/tags/${VERSION}.tar.gz && \
    mkdir -p /build/eccodes && \
    tar -xzf /tmp/eccodes.tar.gz -C /build/eccodes --strip-components=1 && \
    rm -f /tmp/eccodes.tar.gz && \
    cmake -S /build/eccodes -B /build/eccodes/build \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/opt/eccodes \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DCMAKE_PREFIX_PATH=/opt/libaec \
      -DENABLE_TESTS=OFF \
      -DENABLE_EXAMPLES=OFF \
      -DENABLE_FORTRAN=ON \
      -DENABLE_NETCDF=ON \
      -DENABLE_JPG=ON \
      -DENABLE_AEC=ON && \
    cmake --build /build/eccodes/build -j$(nproc) && \
    cmake --install /build/eccodes/build && \
    rm -rf /build/eccodes

FROM $BASE

RUN dnf install -y \
      netcdf \
      openjpeg2 \
      libgfortran && \
    dnf clean all

COPY --from=builder /opt/libaec /opt/libaec
COPY --from=builder /opt/eccodes /opt/eccodes

ENV PATH=/opt/eccodes/bin:$PATH
ENV LD_LIBRARY_PATH=/opt/eccodes/lib:/opt/libaec/lib:$LD_LIBRARY_PATH

USER root

CMD ["grib_ls"]
