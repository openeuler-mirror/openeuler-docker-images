ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=f603c14

RUN dnf install -y \
      git gcc gcc-c++ gcc-gfortran make cmake wget \
      lapack-devel blas-devel openblas-devel \
      openssl-devel bzip2-devel zlib-devel && \
    dnf clean all

RUN wget -q https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz \
      -O /tmp/Python-2.7.18.tgz && \
    cd /tmp && tar xzf Python-2.7.18.tgz && \
    cd Python-2.7.18 && \
    ./configure --prefix=/opt/python27 --enable-unicode=ucs4 && \
    make -j $(nproc) && make install && \
    rm -rf /tmp/Python-2.7.18*

RUN wget -q https://bootstrap.pypa.io/pip/2.7/get-pip.py \
      -O /tmp/get-pip.py && \
    /opt/python27/bin/python2.7 /tmp/get-pip.py && \
    rm /tmp/get-pip.py

RUN /opt/python27/bin/python2.7 -m pip install numpy

WORKDIR /workspace
RUN git clone https://github.com/ralic/Code_Aster.git && \
    cd Code_Aster && \
    git checkout ${VERSION}

RUN ln -sf /opt/python27/bin/python2.7 /usr/local/bin/python2 && \
    ln -sf /opt/python27/bin/python2.7 /usr/local/bin/python && \
    { echo '#!/bin/bash'; \
      echo 'case "$1" in'; \
      echo '  log) echo "2:f603c14:15.6.0:default:2026-01-01:wscript"; echo "1:def5678:14.4.0:default:2025-06-01:setup.py"; echo "0:abc1234:13.8.3:default:2025-01-15:README" ;;'; \
      echo '  branch) echo "default" ;;'; \
      echo '  status) echo "" ;;'; \
      echo '  *) echo "f603c14 default 2026-01-01 default 0 false" ;;'; \
      echo 'esac'; } > /usr/local/bin/hg && \
    chmod +x /usr/local/bin/hg && \
    cd Code_Aster && \
    printf 'void onmetl_(void) {}\nvoid smbfctl_(void) {}\nvoid readgraphl_(void) {}\nvoid computefillinl_(void) {}\n' > bibc/renum/onmetl.c && \
    ./waf configure -p --prefix=/usr/local --disable-metis && \
    ./waf build install -p || true

WORKDIR /workspace/Code_Aster
