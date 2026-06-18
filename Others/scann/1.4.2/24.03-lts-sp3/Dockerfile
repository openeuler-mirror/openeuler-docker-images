ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG VERSION=1.4.2

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

RUN /opt/python39/bin/pip3 install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple scann==${VERSION}
