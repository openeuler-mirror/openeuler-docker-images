ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=2.1.2

ENV QP_ROOT=/opt/qp2

RUN dnf install -y gcc gcc-c++ gfortran make autoconf automake libtool \
    python3 python3-pip python3-devel git wget patch zlib-devel gmp-devel \
    blas-devel lapack-devel pkgconfig ninja-build unzip bzip2 \
    curl ca-certificates \
    ocaml ocaml-devel ocaml-findlib libcap-devel bubblewrap \
    gsl-devel openmpi openmpi-devel m4 gawk && \
    dnf clean all && rm -rf /var/cache/dnf

RUN curl -fsSL https://opam.ocaml.org/install.sh -o /tmp/opam-install.sh && \
    printf '/usr/local/bin\n' | bash /tmp/opam-install.sh && \
    rm -f /tmp/opam-install.sh

RUN python3 -m pip install --no-cache-dir irpf90 resultsFile docopt

RUN git clone -b ${VERSION} --recursive \
    https://github.com/QuantumPackage/qp2.git ${QP_ROOT}

WORKDIR ${QP_ROOT}

RUN mkdir -p ${QP_ROOT}/bin && \
    ln -sf /usr/bin/ninja ${QP_ROOT}/bin/ninja && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    ln -sf /usr/bin/python3 /usr/bin/python2

# 手动构建 ZeroMQ，安装到 QP_ROOT（qp2 内部依赖的统一路径）
RUN cd /tmp && \
    wget -q https://github.com/zeromq/libzmq/releases/download/v4.3.5/zeromq-4.3.5.tar.gz && \
    tar xzf zeromq-4.3.5.tar.gz && \
    cd zeromq-4.3.5 && \
    ./configure --prefix=${QP_ROOT} --without-libsodium && \
    make -j$(nproc) && \
    make install && \
    echo "${QP_ROOT}/lib" > /etc/ld.so.conf.d/qp2.conf && \
    ldconfig && \
    cd / && rm -rf /tmp/zeromq-4.3.5*

# 手动构建 f77zmq（ZeroMQ 的 Fortran 绑定），安装到 QP_ROOT
RUN cd /tmp && \
    wget -q https://github.com/scemama/f77_zmq/archive/v4.2.5.tar.gz -O f77_zmq.tar.gz && \
    tar xzf f77_zmq.tar.gz && \
    cd f77_zmq-4.2.5 && \
    ZMQ_H=${QP_ROOT}/include/zmq.h make && \
    cp libf77zmq.a libf77zmq.so ${QP_ROOT}/lib/ && \
    cp *.h ${QP_ROOT}/include/ && \
    cd / && rm -rf /tmp/f77_zmq-4.2.5 /tmp/f77_zmq.tar.gz

# zeromq 和 f77zmq 已手动安装，只需内部构建 gmp
RUN PKG_CONFIG_PATH=${QP_ROOT}/lib/pkgconfig ./configure -i gmp && \
    bash -c "source quantum_package.rc && make"

ENV PATH=${QP_ROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${QP_ROOT}/lib

CMD ["qp_run", "--help"]
