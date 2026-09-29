ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=0.11.2
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
    && cd / \
    && rm -rf Python-${PYTHON_VERSION} Python-${PYTHON_VERSION}.tgz

RUN echo "/usr/local/python3.12/lib" > /etc/ld.so.conf.d/python3.12.conf \
    && ldconfig \
    && ln -sf /usr/local/python3.12/bin/python3.12 /usr/local/python3.12/bin/python3 \
    && ln -sf /usr/local/python3.12/bin/pip3.12 /usr/local/python3.12/bin/pip3

ENV PATH=/usr/local/python3.12/bin:$PATH

RUN pip3 install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple jax==${VERSION} jaxlib

FROM ${BASE}

COPY --from=builder /usr/local/python3.12 /usr/local/python3.12

RUN printf '/usr/local/python3.12/lib\n' > /etc/ld.so.conf.d/python3.12.conf \
    && ldconfig

ENV PATH=/usr/local/python3.12/bin:$PATH

CMD ["bash"]
