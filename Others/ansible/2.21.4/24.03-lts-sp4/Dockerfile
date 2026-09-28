ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=2.21.4
ARG PYTHON_VERSION=3.12.14

RUN dnf install -y \
      gcc gcc-c++ make \
      curl \
      openssl-devel bzip2-devel libffi-devel zlib-devel \
      readline-devel sqlite-devel xz-devel ncurses-devel expat-devel \
    && dnf clean all

RUN curl -fSL --connect-timeout 30 --max-time 600 --retry 3 --retry-delay 5 \
      -o Python-${PYTHON_VERSION}.tgz \
      https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \
    && echo "6c6df908d2c3fd24e6d76869e92542abd0f33aec9dfc18df8875f89660286d43  Python-${PYTHON_VERSION}.tgz" | sha256sum -c - \
    && tar -zxf Python-${PYTHON_VERSION}.tgz \
    && cd Python-${PYTHON_VERSION} \
    && ./configure --prefix=/usr/local/python3.12 --enable-shared \
    && make -j$(nproc) \
    && make altinstall \
    && echo "/usr/local/python3.12/lib" > /etc/ld.so.conf.d/python3.12.conf \
    && ldconfig \
    && cd / \
    && rm -rf Python-${PYTHON_VERSION} Python-${PYTHON_VERSION}.tgz

ENV PATH=/usr/local/python3.12/bin:$PATH

RUN python3.12 -m pip install --no-cache-dir \
      -i https://pypi.tuna.tsinghua.edu.cn/simple \
      ansible-core==${VERSION}

FROM ${BASE}

COPY --from=builder /usr/local/python3.12 /usr/local/python3.12

RUN printf '/usr/local/python3.12/lib\n' > /etc/ld.so.conf.d/python3.12.conf \
    && ldconfig

ENV PATH=/usr/local/python3.12/bin:$PATH

CMD ["bash"]

USER root
