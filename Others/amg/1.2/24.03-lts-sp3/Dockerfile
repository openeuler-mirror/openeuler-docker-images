ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG VERSION=1.2

RUN dnf install -y \
      git gcc make \
      openmpi-devel && \
    dnf clean all

ENV PATH=$PATH:/usr/lib64/openmpi/bin

RUN git clone --depth 1 --branch ${VERSION} https://github.com/llnl/AMG.git /tmp/AMG && \
    cd /tmp/AMG && \
    sed -i 's|^MPICC *=.*|MPICC = mpicc|' Makefile.include && \
    sed -i 's|^INCLUDE_CFLAGS *=.*|INCLUDE_CFLAGS = -DHYPRE_BIGINT -DTIMER_USE_MPI|' Makefile.include && \
    make && \
    cp test/amg /usr/local/bin/amg && \
    rm -rf /tmp/AMG

CMD ["mpirun", "--allow-run-as-root", "amg"]
