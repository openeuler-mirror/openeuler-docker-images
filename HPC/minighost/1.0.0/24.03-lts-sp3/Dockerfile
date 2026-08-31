ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

# miniGhost has no release tags, so we pin the build to a fixed commit
# and treat it as version 1.0.0 to keep the image reproducible.
ARG VERSION=1.0.0
ARG MINIGHOST_COMMIT=c2102b521568a74862fa5abb074b1fc8041fc222

RUN yum install -y git gfortran openmpi-devel make && \
    yum clean all

ENV PATH=/usr/lib64/openmpi/bin:$PATH

WORKDIR /opt
RUN git clone https://github.com/Mantevo/miniGhost && \
    cd miniGhost && \
    git checkout ${MINIGHOST_COMMIT} && \
    cd ref && \
    sed -i 's|^MPI_LOC.*=.*|MPI_LOC=|' makefile.mpi.gnu && \
    sed -i 's|^MPI_INCLUDE.*=.*|MPI_INCLUDE=|' makefile.mpi.gnu && \
    sed -i 's|^FC.*=.*|FC=mpif90|' makefile.mpi.gnu && \
    sed -i 's|^CC.*=.*|CC=mpicc|' makefile.mpi.gnu && \
    sed -i 's|^LD.*=.*|LD=mpif90|' makefile.mpi.gnu && \
    sed -i 's|^FFLAGS = $(PROTOCOL)|FFLAGS = -fallow-argument-mismatch -ffree-line-length-none $(PROTOCOL)|' makefile.mpi.gnu && \
    make -f makefile.mpi.gnu

WORKDIR /opt/miniGhost/ref

CMD ["mpirun", "--allow-run-as-root", "-np", "4", "./miniGhost.x"]
