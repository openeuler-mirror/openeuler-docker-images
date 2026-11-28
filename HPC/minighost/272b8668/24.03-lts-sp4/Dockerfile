ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

# miniGhost has no release tags, so we pin the build to a fixed commit
# to keep the image reproducible.
ARG VERSION=272b8668b7adffa772a0573e74c0a31cf141906b
ARG MINIGHOST_COMMIT=272b8668b7adffa772a0573e74c0a31cf141906b

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
