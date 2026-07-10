ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=6-40-00

RUN dnf install -y \
      git make cmake gcc gcc-c++ binutils \
      openssl-devel python3-devel \
      libX11-devel libXpm-devel libXft-devel libXext-devel \
      pcre-devel readline-devel libxml2-devel \
      libuuid-devel zlib-devel freetype-devel \
      zstd-devel giflib-devel libjpeg-turbo-devel lz4-devel && \
    dnf clean all

RUN git clone --branch v${VERSION} --depth=1 https://github.com/root-project/root.git /root-src && \
    mkdir /root-build && cd /root-build && \
    cmake -DCMAKE_INSTALL_PREFIX=/opt/root \
          -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_CXX_STANDARD=17 \
          -Dtesting=OFF -Droottest=OFF \
          /root-src && \
    cmake --build . -- -j$(nproc) && \
    cmake --install . && \
    rm -rf /root-src /root-build

ENV ROOTSYS=/opt/root
ENV PATH=${ROOTSYS}/bin:${PATH}
ENV LD_LIBRARY_PATH=${ROOTSYS}/lib:${LD_LIBRARY_PATH}
ENV PYTHONPATH=${ROOTSYS}/lib:${PYTHONPATH}

CMD ["root", "-b"]
