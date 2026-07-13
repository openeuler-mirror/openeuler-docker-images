ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=1.2.1

RUN dnf install -y \
      gcc gcc-c++ make findutils \
      curl wget \
      openssl-devel bzip2-devel libffi-devel zlib-devel \
      readline-devel sqlite-devel \
      openmpi-devel openmpi && \
    dnf clean all

RUN curl -fSL -o /tmp/Python-3.12.6.tgz https://www.python.org/ftp/python/3.12.6/Python-3.12.6.tgz && \
    tar -zxf /tmp/Python-3.12.6.tgz -C /tmp && \
    cd /tmp/Python-3.12.6 && \
    ./configure --prefix=/usr/local/python3.12 --enable-shared && \
    make -j$(nproc) && \
    make altinstall && \
    cd / && rm -rf /tmp/Python-3.12.6 /tmp/Python-3.12.6.tgz

RUN echo /usr/local/python3.12/lib > /etc/ld.so.conf.d/python3.12.conf && ldconfig

RUN ln -sf /usr/local/python3.12/bin/python3.12 /usr/local/bin/python3 && \
    ln -sf /usr/local/python3.12/bin/pip3.12 /usr/local/bin/pip3

RUN pip3 install --no-cache-dir --index-url https://download.pytorch.org/whl/cu130 torch==2.9.1

RUN pip3 install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple cuda-toolkit==13.1.0

RUN pip3 install --no-cache-dir --extra-index-url https://pypi.nvidia.com/ tensorrt_llm==${VERSION}

CMD ["/bin/bash"]
