ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder
ARG VERSION=4.1
RUN dnf install -y \
      gcc gcc-c++ make \
      git && \
    dnf clean all
RUN git clone --branch v${VERSION} --depth=1 https://github.com/mfem/mfem.git /mfem-src && \
    cd /mfem-src && \
    make serial -j"$(nproc)" && \
    make examples -j"$(nproc)" && \
    make install PREFIX=/usr/local && \
    mkdir -p /usr/local/share/mfem && \
    cp -r examples data /usr/local/share/mfem/ && \
    rm -rf /mfem-src

FROM ${BASE}
COPY --from=builder /usr/local /usr/local
WORKDIR /workspace
USER root
CMD ["/bin/bash"]
