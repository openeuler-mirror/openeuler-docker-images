ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=2.2.2

ENV QP_ROOT=/opt/qp2

RUN dnf install -y gcc gcc-c++ gfortran make autoconf automake libtool \
    python3 python3-pip python3-devel git wget patch zlib-devel gmp-devel \
    blas-devel lapack-devel pkgconfig ninja-build unzip bzip2 \
    curl ca-certificates which findutils \
    gsl-devel openmpi openmpi-devel m4 gawk hdf5-devel && \
    dnf clean all && rm -rf /var/cache/dnf

RUN python3 -m pip install --no-cache-dir irpf90 resultsFile docopt

RUN git clone -b v${VERSION} --recursive \
    https://github.com/QuantumPackage/qp2.git ${QP_ROOT}

WORKDIR ${QP_ROOT}

RUN ./configure -i all && \
    ./configure -c config/gfortran.cfg && \
    bash -c "source quantum_package.rc && make"

ENV PATH=${QP_ROOT}/bin:${QP_ROOT}/ocaml:${PATH}
ENV LD_LIBRARY_PATH=${QP_ROOT}/lib

CMD ["qp_run", "--help"]
