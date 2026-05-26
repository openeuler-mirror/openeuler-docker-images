ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE
ARG VERSION=4.46
ARG BUILD=300
ARG TARGETARCH
RUN yum install -y \
        gcc gcc-c++ make cmake git which \
        libuuid-devel wget && \
    yum clean all && rm -rf /var/cache/yum
RUN git clone https://github.com/copasi/copasi-dependencies /copasi-deps && \
    mkdir -p /copasi-deps/build && cd /copasi-deps/build && \
    cmake -DBUILD_UI_DEPS=OFF -DBUILD_raptor=ON \
        -DCMAKE_INSTALL_PREFIX=/copasi-deps/bin .. && \
    make -j $(nproc) && \
    find /copasi-deps/src/raptor -name "raptor.h" -exec cp {} /copasi-deps/bin/include/ \; && \
    rm -rf /copasi-deps/build /copasi-deps/.git
RUN git clone -b Build-${BUILD} \
    https://github.com/copasi/COPASI.git /COPASI && \
    cd /COPASI && ./gitTools/UpdateCopasiVersion && \
    rm -rf .git
WORKDIR /build
RUN JIT_FLAG=""; \
    if [ "$TARGETARCH" = "arm64" ]; then JIT_FLAG="-DENABLE_JIT=OFF"; fi && \
    cmake ../COPASI \
        -DBUILD_GUI=OFF \
        -DCOPASI_DEPENDENCY_DIR=/copasi-deps/bin \
        $JIT_FLAG \
        -DCOPASI_OVERRIDE_VERSION=${VERSION}.${BUILD} \
        -DCMAKE_INSTALL_PREFIX=/opt/COPASI && \
    make -j $(nproc) && \
    make install && \
    cd / && rm -rf /build /COPASI /copasi-deps
ENV COPASIDIR=/opt/COPASI
ENV PATH=/opt/COPASI/bin:$PATH
WORKDIR /workspace
CMD ["/bin/bash"]