ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION=1.4.2
ARG COMMIT=7117df5

RUN dnf install -y \
      gcc gcc-c++ make wget \
      openssl-devel bzip2-devel zlib-devel && \
    dnf clean all

RUN wget -q https://www.python.org/ftp/python/3.9.19/Python-3.9.19.tgz \
      -O /tmp/Python-3.9.19.tgz && \
    cd /tmp && tar xzf Python-3.9.19.tgz && \
    cd Python-3.9.19 && \
    ./configure --prefix=/opt/python39 --with-ensurepip=install && \
    make -j $(nproc) && make install && \
    rm -rf /tmp/Python-3.9.19*

ENV PATH=/opt/python39/bin:$PATH

LABEL org.opencontainers.image.source="https://github.com/google-research/google-research" \
      org.opencontainers.image.revision="${COMMIT}"

RUN /opt/python39/bin/pip3 install --no-cache-dir -i https://pypi.org/simple scann==${VERSION}
