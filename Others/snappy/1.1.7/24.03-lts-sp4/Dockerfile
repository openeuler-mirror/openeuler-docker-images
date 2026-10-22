ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=1.1.7

RUN sed -i '/^meta/ s/^\(.*\)$/#\1/g' /etc/yum.repos.d/openEuler.repo \
    && dnf install -y \
      gcc-c++ cmake make \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN curl -fSL --connect-timeout 30 --max-time 600 --retry 3 --retry-delay 5 \
      -o snappy-${VERSION}.tar.gz \
      https://github.com/google/snappy/archive/refs/tags/${VERSION}.tar.gz \
    && echo "3dfa02e873ff51a11ee02b9ca391807f0c8ea0529a4924afa645fbf97163f9d4  snappy-${VERSION}.tar.gz" | sha256sum -c - \
    && tar -zxf snappy-${VERSION}.tar.gz \
    && rm snappy-${VERSION}.tar.gz

WORKDIR /opt/snappy-${VERSION}/build

RUN cmake -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_INSTALL_PREFIX=/usr/local \
          -DBUILD_SHARED_LIBS=ON .. \
    && make -j$(nproc) \
    && make install DESTDIR=/opt/snappy \
    && mkdir -p /opt/snappy/usr/local/share/licenses/snappy \
    && cp ../COPYING /opt/snappy/usr/local/share/licenses/snappy/COPYING

FROM ${BASE}

ARG VERSION=1.1.7

COPY --from=builder /opt/snappy/usr/local/ /usr/local/

# snappy installs via GNUInstallDirs, which resolves to lib64 on openEuler
# (RedHat-style layout for both amd64 and arm64), so the runtime loader path
# and pkg-config search path must follow lib64 as well.
RUN printf '/usr/local/lib64\n' > /etc/ld.so.conf.d/snappy.conf \
    && ldconfig

ENV PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig

USER root

CMD ["bash"]
