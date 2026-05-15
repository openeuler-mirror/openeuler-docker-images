ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE} AS build

ARG VERSION=4.3

RUN yum update -y && \
    yum install -y gcc g++ gfortran openssh-clients bzip2 \
        ca-certificates git make patch pkgconfig unzip wget \
        openmpi openmpi-devel fftw fftw-devel \
        blas blas-devel lapack lapack-devel && \
    yum clean all

RUN git clone -b ${VERSION} --depth 1 https://github.com/CPMD-code/CPMD.git /opt/cpmd

WORKDIR /opt/cpmd
ARG TARGETARCH
RUN chmod +x configure.sh && \
    ARCH="${TARGETARCH:-$(uname -m)}" && \
    if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then \
        sed -e 's/gfortran/mpif90/g' configure/LINUX-GFORTRAN > configure/LINUX-AARCH64-GFORTRAN-MPI; \
        CPMD_TARGET="LINUX-AARCH64-GFORTRAN-MPI"; \
    else \
        CPMD_TARGET="LINUX-X86_64-GFORTRAN-MPI"; \
    fi && \
    ./configure.sh -omp ${CPMD_TARGET} && \
    sed -i 's/FFLAGS = .*/FFLAGS = -O2 -Wall -Wno-maybe-uninitialized -fallow-argument-mismatch -fopenmp -I$(SRCDIR) -I$(OBJDIR)/' Makefile && \
    sed -i 's|/home/manish/[^ ]*\.a /home/manish/[^ ]*\.a|-llapack -lblas|g' Makefile && \
    sed -i 's/-static//' Makefile && \
    make -j $(nproc)

RUN mkdir -p /opt/cpmd-install/bin && \
    cp /opt/cpmd/bin/cpmd.x /opt/cpmd-install/bin/

FROM ${BASE}
RUN yum install -y gcc g++ gfortran openssh-clients openmpi openmpi-devel \
        fftw fftw-devel blas lapack && \
    yum clean all

COPY --from=build /opt/cpmd-install/bin/cpmd.x /usr/local/bin/cpmd.x

RUN printf "#!/bin/bash\n\
ulimit -c 0 -s unlimited\n\
export OMPI_ALLOW_RUN_AS_ROOT=1\n\
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1\n\
export OMPI_MCA_btl_vader_single_copy_mechanism=none\n\
export OMP_STACKSIZE=16M\n\
\"\$@\"" \
>/usr/local/bin/entrypoint.sh && chmod 755 /usr/local/bin/entrypoint.sh

WORKDIR /mnt
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["cpmd.x", "--help"]