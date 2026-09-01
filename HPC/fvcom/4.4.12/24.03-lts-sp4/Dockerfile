ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE

ARG FVCOM_VERSION=release-v4.4.12
ARG NETCDF_FORTRAN_VERSION=4.6.1

RUN yum install -y \
        gcc gcc-c++ gcc-gfortran make cmake tar gzip curl git \
        python3 openmpi-devel netcdf-devel hdf5-devel zlib-devel \
        libcurl-devel && \
    yum clean all && rm -rf /var/cache/yum

RUN curl -fsSL https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v${NETCDF_FORTRAN_VERSION}.tar.gz -o netcdf-fortran.tgz && \
    tar xzf netcdf-fortran.tgz && \
    cd netcdf-fortran-${NETCDF_FORTRAN_VERSION} && \
    mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local \
          -DENABLE_PARALLEL_TESTS=OFF .. && \
    make -j$(nproc) && make install && \
    cd / && rm -rf netcdf-fortran-${NETCDF_FORTRAN_VERSION} netcdf-fortran.tgz


RUN git clone --depth=1 --branch ${FVCOM_VERSION} \
        https://github.com/FVCOM-GitHub/FVCOM.git /fvcom


RUN cd /fvcom/src && python3 - <<'PYEOF'
import io, re
p = "make.inc"
s = io.open(p, encoding="latin-1").read()


s = re.sub(r'^(\s*)include \$\{PETSC_DIR\}/bmake/common/variables\s*$',
           r'#\1include ${PETSC_DIR}/bmake/common/variables', s, flags=re.M)

s += """

TOPDIR   = /fvcom/src
COMPILER = -DGFORTRAN
CPP      = /usr/bin/cpp
CC       = mpicc
CXX      = mpicxx
FC       = mpif90
CFLAGS   = -O3
DEBFLGS  =
OPT      = -O3
LIBDIR   = -L/usr/local/lib -L/usr/local/lib64 -L/usr/lib64 -L/usr/lib
INCDIR   = -I/usr/local/include -I/usr/include -I/usr/local/lib/gfortran/modules -I/usr/local/lib64/gfortran/modules -I/usr/lib64/gfortran/modules
FLAG_7   =
FLAG_9   =
FLAG_41  =
FLAG_411 =
PARLIB   = -lmetis
PARTINCS =
PARTLIBS =
IOLIBS   = -lnetcdff -lnetcdf -lhdf5_hl -lhdf5 -lz -lcurl -lm
DTLIBS   = -ljulian
"""

io.open(p, "w", encoding="latin-1").write(s)
PYEOF


RUN mkdir -p /usr/local/lib /usr/local/include && \
    cd /fvcom/src/libs && tar xzf metis.tgz && tar xzf julian.tgz && \
    cd metis && make CC=gcc libmetis.a && \
    cp libmetis.a /usr/local/lib/ && \
    cp proto.h struct.h metis.h /usr/local/include/ 2>/dev/null || true && \
    cd ../julian && make CC=gcc FC=gfortran libjulian && \
    cp libjulian.a /usr/local/lib/ && \
    cp fjulian.inc /usr/local/include/


RUN MPI_BIN=$(dirname "$(find /usr -name mpif90 -type f 2>/dev/null | head -n1)") && \
    export PATH="$MPI_BIN:$PATH" && \
    export LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:${LD_LIBRARY_PATH} && \
    cd /fvcom/src && make clean && make -j3


RUN MPI_BIN=$(find /usr -name mpif90 -type f 2>/dev/null | head -n1) && \
    MPI_PREFIX=$(dirname "$(dirname "$MPI_BIN")") && \
    cp /fvcom/src/fvcom /usr/local/bin/ && \
    rm -rf /fvcom && \
    printf 'export PATH=%s:$PATH\n' "$(dirname "$MPI_BIN")" > /etc/profile.d/fvcom.sh && \
    printf 'export LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:%s/lib:%s/lib64:$LD_LIBRARY_PATH\n' "$MPI_PREFIX" "$MPI_PREFIX" >> /etc/profile.d/fvcom.sh

WORKDIR /workspace
CMD ["/bin/bash"]