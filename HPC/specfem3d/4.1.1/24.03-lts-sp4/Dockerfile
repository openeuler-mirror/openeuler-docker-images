ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG TARGETARCH
ARG VERSION=4.1.1

RUN dnf update -y && \
    dnf install -y gcc gcc-c++ gfortran make openmpi-devel git zlib-devel && \
    dnf clean all && \
    rm -rf /var/cache/dnf

WORKDIR /opt

RUN git clone --depth=1 --recursive --branch v${VERSION} https://github.com/SPECFEM/specfem3d.git

WORKDIR /opt/specfem3d

RUN ./configure FC=gfortran CC=gcc MPIFC=mpif90 --with-mpi --enable-vectorization && \
    make -j$(nproc) all

FROM ${BASE}

ARG TARGETARCH

RUN dnf install -y openmpi gfortran zlib && \
    dnf clean all

COPY --from=builder /opt/specfem3d/bin/ /opt/specfem3d/bin/
COPY --from=builder /opt/specfem3d/DATA/ /opt/specfem3d/DATA/
COPY --from=builder /opt/specfem3d/EXAMPLES/ /opt/specfem3d/EXAMPLES/
COPY --from=builder /opt/specfem3d/run_this_example.sh /opt/specfem3d/

ENV PATH=/opt/specfem3d/bin:$PATH
ENV OMPI_MCA_btl_vader_single_copy_mechanism=none
ENV OMPI_ALLOW_RUN_AS_ROOT=1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

WORKDIR /opt/specfem3d

CMD ["./run_this_example.sh"]