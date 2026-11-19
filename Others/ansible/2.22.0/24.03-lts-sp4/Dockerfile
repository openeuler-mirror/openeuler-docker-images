ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION=2.22.0
ARG PYTHON_VERSION=3.13.18

RUN dnf install -y \
      gcc gcc-c++ make \
      curl \
      openssl-devel bzip2-devel libffi-devel zlib-devel \
      readline-devel sqlite-devel xz-devel ncurses-devel expat-devel \
    && dnf clean all

RUN curl -fSL --connect-timeout 30 --max-time 600 --retry 3 --retry-delay 5 \
      -o Python-${PYTHON_VERSION}.tgz \
      https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \
    && echo "99dbc847fb6a3fb26358370fb4c591215864116ebb584f2b89ab0b74c51dfa2a  Python-${PYTHON_VERSION}.tgz" | sha256sum -c - \
    && tar -zxf Python-${PYTHON_VERSION}.tgz \
    && cd Python-${PYTHON_VERSION} \
    && ./configure --prefix=/usr/local/python3.13 --enable-shared \
    && make -j$(nproc) \
    && make altinstall \
    && echo "/usr/local/python3.13/lib" > /etc/ld.so.conf.d/python3.13.conf \
    && ldconfig \
    && cd / \
    && rm -rf Python-${PYTHON_VERSION} Python-${PYTHON_VERSION}.tgz

ENV PATH=/usr/local/python3.13/bin:$PATH

RUN python3.13 -m pip install --no-cache-dir \
      ansible-core==${VERSION}

FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

COPY --from=builder /usr/local/python3.13 /usr/local/python3.13

RUN printf '/usr/local/python3.13/lib\n' > /etc/ld.so.conf.d/python3.13.conf \
    && ldconfig

ENV PATH=/usr/local/python3.13/bin:$PATH

CMD ["bash"]

USER root
