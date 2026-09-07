ARG BASE=openeuler/openeuler:24.03-lts-sp4

FROM $BASE AS builder

ARG VERSION=4.4.12
ARG NETCDF_FORTRAN_VERSION=4.6.1

ENV PATH=/usr/lib64/openmpi/bin:$PATH \
    LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:/usr/lib64/openmpi/lib

RUN yum install -y --disablerepo=update --disablerepo=update-source \
        gcc gcc-c++ gcc-gfortran make cmake tar gzip curl git patch \
        openmpi-devel netcdf-devel hdf5-devel zlib-devel \
        libcurl-devel && \
    yum clean all && rm -rf /var/cache/yum

RUN curl -fSL --retry 5 --retry-delay 5 --retry-all-errors \
        https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v${NETCDF_FORTRAN_VERSION}.tar.gz \
        -o netcdf-fortran.tgz && \
    tar xzf netcdf-fortran.tgz && \
    cd netcdf-fortran-${NETCDF_FORTRAN_VERSION} && \
    mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local \
          -DENABLE_PARALLEL_TESTS=OFF .. && \
    make -j4 && make install && \
    cd / && rm -rf netcdf-fortran-${NETCDF_FORTRAN_VERSION} netcdf-fortran.tgz


RUN for i in $(seq 1 5); do \
        git clone --depth=1 --branch release-v${VERSION} \
            https://github.com/FVCOM-GitHub/FVCOM.git /fvcom && exit 0; \
        echo "git clone failed (attempt $i/5), retrying..."; \
        rm -rf /fvcom; sleep 5; \
    done; echo "git clone failed after 5 attempts"; exit 1


COPY make.inc /fvcom/src/make.inc

COPY fvcom-gfortran.patch /fvcom/src/fvcom-gfortran.patch
RUN cd /fvcom/src && patch -p1 < fvcom-gfortran.patch


RUN mkdir -p /usr/local/lib /usr/local/include && \
    cd /fvcom/src/libs && tar xzf metis.tgz && tar xzf julian.tgz && \
    cd metis && \
    sed -i 's/^#define log2[[:space:]]*__log2/#define log2 metis_log2/' rename.h && \
    make CC=gcc libmetis.a && \
    cp libmetis.a /usr/local/lib/ && \
    (cp proto.h struct.h metis.h /usr/local/include/ 2>/dev/null || true) && \
    cd ../julian && make CC=gcc FC=gfortran libjulian && \
    cp libjulian.a /usr/local/lib/ && \
    cp fjulian.inc /usr/local/include/


RUN cd /fvcom/src && make clean && make && \
    cp /fvcom/src/fvcom /usr/local/bin/ && \
    rm -rf /fvcom

RUN ldd /usr/local/bin/fvcom | grep -q "not found" && \
    echo "fvcom has unresolved shared library dependencies" && exit 1 || \
    echo "fvcom shared library dependencies OK"


FROM $BASE

ENV PATH=/usr/lib64/openmpi/bin:$PATH \
    LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:/usr/lib64/openmpi/lib

RUN yum install -y --disablerepo=update --disablerepo=update-source \
        openmpi netcdf hdf5 libcurl zlib libgfortran && \
    yum clean all && rm -rf /var/cache/yum

COPY --from=builder /usr/local/bin/fvcom /usr/local/bin/fvcom
COPY --from=builder /usr/local/lib64/libnetcdff.so* /usr/local/lib64/

RUN ldd /usr/local/bin/fvcom | grep -q "not found" && \
    echo "fvcom has unresolved shared library dependencies" && exit 1 || \
    echo "fvcom shared library dependencies OK"

WORKDIR /workspace
CMD ["/bin/bash"]
