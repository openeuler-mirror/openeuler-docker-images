ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG QMP_VERSION=2-5-2
ARG QDP_VERSION=1-46-0
ARG VERSION=3-44-0

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN dnf install -y gcc gcc-c++ gcc-gfortran make autoconf automake \
    libtool libxml2-devel openmpi-devel wget git patch \
    && git config --global url."https://github.com/".insteadOf git@github.com: \
    && git config --global url."https://github.com/".insteadOf git://github.com/ \
    && dnf clean all \
    && rm -rf /var/cache/dnf

ENV PATH=/usr/lib64/openmpi/bin:${PATH:-}
ENV LD_LIBRARY_PATH=/usr/lib64/openmpi/lib

WORKDIR /opt

RUN set -ex \
    && wget https://github.com/usqcd-software/qmp/archive/refs/tags/qmp${QMP_VERSION}.tar.gz \
    && tar -xzf qmp${QMP_VERSION}.tar.gz \
    && cd qmp-qmp${QMP_VERSION} \
    && autoreconf -fi \
    && ./configure --prefix=/opt/qmp-install --enable-parallel-arch=scalar \
    && make -j$(nproc) \
    && make install \
    && test -d /opt/qmp-install/lib \
    && cd /opt \
    && rm -rf qmp${QMP_VERSION}.tar.gz qmp-qmp${QMP_VERSION}

RUN set -ex \
    && git clone --branch qdp${QDP_VERSION} https://github.com/usqcd-software/qdpxx.git qdp++ \
    && cd qdp++ \
    && if [ -f .gitmodules ]; then sed -i 's|git@github.com:|https://github.com/|g' .gitmodules; fi \
    && git submodule sync --recursive \
    && git submodule update --init --recursive \
    && autoreconf -fi \
    && CXXFLAGS="-std=c++14" ./configure --prefix=/opt/qdp-install \
        --with-qmp=/opt/qmp-install \
        --enable-parallel-arch=scalar \
    && make -j$(nproc) \
    && make install \
    && test -d /opt/qdp-install/lib \
    && cd /opt \
    && rm -rf qdp++

RUN set -ex \
    && git clone --branch chroma-${VERSION} https://github.com/JeffersonLab/chroma.git chroma \
    && cd chroma \
    && sed -i 's|git@github.com:|https://github.com/|g' .gitmodules \
    && git submodule sync --recursive \
    && git submodule update --init --recursive \
    && autoreconf -fi \
    && CXXFLAGS="-std=c++14" ./configure --prefix=/opt/chroma-install \
        --with-qdp=/opt/qdp-install \
    && make -j$(nproc) \
    && make install \
    && test -d /opt/chroma-install/lib \
    && cd /opt \
    && rm -rf chroma

FROM ${BASE}

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

COPY --from=builder /opt/chroma-install /opt/chroma
COPY --from=builder /opt/qdp-install /opt/qdp
COPY --from=builder /opt/qmp-install /opt/qmp

ENV PATH=/opt/chroma/bin:${PATH:-}
ENV LD_LIBRARY_PATH=/opt/chroma/lib:/opt/qdp/lib:/opt/qmp/lib

WORKDIR /opt/chroma

CMD ["bash"]