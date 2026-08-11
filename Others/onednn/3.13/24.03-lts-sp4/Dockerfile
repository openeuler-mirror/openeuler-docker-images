ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=3.13

RUN dnf install -y \
      gcc gcc-c++ make cmake \
      wget && \
    dnf clean all

WORKDIR /opt

RUN wget -q -T 30 --tries 3 https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v${VERSION}.tar.gz \
    && tar -zxf v${VERSION}.tar.gz \
    && mv oneDNN-${VERSION} oneDNN \
    && rm -f v${VERSION}.tar.gz

WORKDIR /opt/oneDNN/build

RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local \
          -DCMAKE_INSTALL_LIBDIR=lib \
          -DONEDNN_BUILD_EXAMPLES=OFF \
          -DONEDNN_BUILD_TESTS=OFF \
          .. \
    && cmake --build . --parallel $(nproc) \
    && cmake --install .

RUN g++ -std=c++11 -O2 -fopenmp \
        -I/usr/local/include \
        -I/opt/oneDNN/examples \
        /opt/oneDNN/examples/getting_started.cpp \
        -L/usr/local/lib \
        -Wl,-rpath,/usr/local/lib \
        -ldnnl \
        -o /usr/local/bin/onednn-getting-started

FROM ${BASE}

COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /usr/local/include /usr/local/include
COPY --from=builder /usr/local/bin/onednn-getting-started /usr/local/bin/onednn-getting-started
COPY --from=builder /usr/local/share/doc/dnnl /usr/local/share/doc/dnnl

RUN echo /usr/local/lib > /etc/ld.so.conf.d/onednn.conf && ldconfig

USER root

CMD ["onednn-getting-started"]
