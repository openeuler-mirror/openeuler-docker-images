ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION=2.12.0

RUN dnf install -y curl && \
    curl -fSL -o apache-parquet-format-${VERSION}.tar.gz https://archive.apache.org/dist/parquet/apache-parquet-format-${VERSION}/apache-parquet-format-${VERSION}.tar.gz && \
    curl -fSL -o apache-parquet-format-${VERSION}.tar.gz.sha512 https://archive.apache.org/dist/parquet/apache-parquet-format-${VERSION}/apache-parquet-format-${VERSION}.tar.gz.sha512 && \
    sha512sum -c apache-parquet-format-${VERSION}.tar.gz.sha512 && \
    mkdir -p /usr/local/parquet && \
    tar -zxf apache-parquet-format-${VERSION}.tar.gz -C /usr/local/parquet --strip-components=1 && \
    rm -rf apache-parquet-format-${VERSION}.tar.gz apache-parquet-format-${VERSION}.tar.gz.sha512

CMD [ "/bin/bash" ]
