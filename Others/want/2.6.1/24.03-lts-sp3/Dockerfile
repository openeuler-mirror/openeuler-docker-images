ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG WANT_VERSION=2.6.1

RUN dnf install -y \
        gcc gcc-gfortran gcc-c++ make \
        fftw-devel \
        git \
    && dnf clean all

RUN git clone --depth 1 --branch want-${WANT_VERSION} https://github.com/QEF/want.git /tmp/want && \
    cd /tmp/want && \
    ./configure --build=$(uname -m)-unknown-linux-gnu --with-internal-libs --disable-parallel && \
    sed -i '/^F90FLAGS/s/$/ -fallow-argument-mismatch/' make.sys && \
    sed -i '/^FFLAGS/s/$/ -fallow-argument-mismatch/' make.sys && \
    make all && \
    cp bin/* /usr/local/bin/ && \
    rm -rf /tmp/want

CMD ["/bin/bash"]
