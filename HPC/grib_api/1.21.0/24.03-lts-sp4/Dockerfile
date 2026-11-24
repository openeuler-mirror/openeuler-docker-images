ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION=1.21.0

RUN dnf install -y \
      git gcc gcc-c++ cmake make \
      openjpeg2-devel && \
    dnf clean all

RUN git clone --branch v${VERSION} --depth 1 https://github.com/weathersource/grib_api.git /tmp/grib_api && \
    mkdir /tmp/grib_api/build && \
    cd /tmp/grib_api/build && \
    cmake .. \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DCMAKE_BUILD_TYPE=Release \
      -DENABLE_PYTHON=OFF \
      -DENABLE_FORTRAN=OFF \
      -DENABLE_PNG=OFF \
      -DENABLE_NETCDF=OFF \
      -DENABLE_AEC=OFF && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/grib_api

ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

CMD ["grib_ls"]
