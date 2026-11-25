ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)
ARG VERSION=1.7.19

RUN dnf install -y \
    wget \
    gcc-c++ \
    make \
    cmake \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN wget https://github.com/DaveGamble/cJSON/archive/refs/tags/v${VERSION}.tar.gz \
    && echo "7fa616e3046edfa7a28a32d5f9eacfd23f92900fe1f8ccd988c1662f30454562  v${VERSION}.tar.gz" | sha256sum -c - \
    && tar -zxvf v${VERSION}.tar.gz \
    && rm -f v${VERSION}.tar.gz

WORKDIR /opt/cJSON-${VERSION}/build

RUN cmake .. -DENABLE_CJSON_UTILS=On -DENABLE_CJSON_TEST=Off -DCMAKE_INSTALL_PREFIX=/usr \
    && make -j$(nproc) \
    && make install

CMD ["bash"]
