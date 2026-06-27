ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE} AS builder

ARG VERSION=5.5.2Oct2024
ARG NETCDF_FORTRAN_VERSION=4.5.3
ARG IOAPI_VERSION=20200828

RUN dnf install -y \
      git gcc-gfortran gcc-c++ make cmake m4 \
      openmpi-devel netcdf-devel hdf5-devel \
      libcurl-devel tcsh && \
    dnf clean all

ENV MPI_HOME=/usr/lib64/openmpi
ENV NETCDF=/usr

RUN curl -fSL -o netcdf-fortran.tar.gz \
      https://github.com/Unidata/netcdf-fortran/archive/v${NETCDF_FORTRAN_VERSION}.tar.gz && \
    mkdir -p /tmp/netcdf-fortran && \
    tar -zxf netcdf-fortran.tar.gz -C /tmp/netcdf-fortran --strip-components=1 && \
    rm -f netcdf-fortran.tar.gz && \
    cd /tmp/netcdf-fortran && \
    export LD_LIBRARY_PATH=/usr/lib64/openmpi/lib:$LD_LIBRARY_PATH && \
    export CPPFLAGS="-I/usr/include -I/usr/lib64/openmpi/include" && \
    export LDFLAGS="-L/usr/lib64 -L/usr/lib64/openmpi/lib" && \
    export LIBS="-lnetcdf -lhdf5 -lz -lcurl" && \
    ./configure --prefix=/usr/local/netcdf-fortran && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/netcdf-fortran

RUN curl -fSL -o ioapi.tar.gz \
      https://github.com/cjcoats/ioapi-3.2/archive/${IOAPI_VERSION}.tar.gz && \
    mkdir -p /tmp/ioapi && \
    tar -zxf ioapi.tar.gz -C /tmp/ioapi --strip-components=1 && \
    rm -f ioapi.tar.gz && \
    cd /tmp/ioapi && \
    export BIN=Linux2_x86_64gfort && \
    export BASEDIR=/tmp/ioapi && \
    export CPLMODE=nocpl && \
    export NCFLIBS="-L/usr/lib64 -lnetcdf -L/usr/local/netcdf-fortran/lib -lnetcdff" && \
    export LIBS="-L/usr/lib64 -lnetcdf -L/usr/local/netcdf-fortran/lib -lnetcdff -L/usr/lib64 -lhdf5 -lz -lcurl -lm" && \
    cp Makefile.template Makefile && \
    sed -i 's/OMPFLAGS = -fopenmp/OMPFLAGS =/g' Makefile && \
    sed -i 's/OMPLIBS = -fopenmp/OMPLIBS =/g' Makefile && \
    touch ioapi/Makefile m3tools/Makefile && \
    make configure && \
    sed -i 's/-fopenmp//g' ioapi/Makeinclude.Linux2_x86_64gfort && \
    sed -i 's/OMPFLAGS/#OMPFLAGS/g' ioapi/Makeinclude.Linux2_x86_64gfort && \
    sed -i 's/OMPLIBS/#OMPLIBS/g' ioapi/Makeinclude.Linux2_x86_64gfort && \
    sed -i 's/-m64//g' ioapi/Makeinclude.Linux2_x86_64gfort && \
    sed -i '/^FOPTFLAGS/s/$/ -fallow-argument-mismatch/' ioapi/Makeinclude.Linux2_x86_64gfort && \
    make lib && \
    mkdir -p /usr/local/ioapi/lib /usr/local/ioapi/include && \
    cp Linux2_x86_64gfort/libioapi.a /usr/local/ioapi/lib/ && \
    cp Linux2_x86_64gfort/*.mod /usr/local/ioapi/include/ && \
    cp ioapi/*.EXT /usr/local/ioapi/include/ && \
    rm -rf /tmp/ioapi

RUN git clone -b CMAQv5.5_2Oct2024 --depth 1 https://github.com/USEPA/CMAQ.git /opt/cmaq

FROM ${BASE}

RUN dnf install -y \
      gcc-gfortran openmpi netcdf hdf5 \
      libcurl tcsh && \
    dnf clean all

COPY --from=builder /usr/local/netcdf-fortran /usr/local/netcdf-fortran
COPY --from=builder /usr/local/ioapi /usr/local/ioapi
COPY --from=builder /opt/cmaq /opt/cmaq

ENV MPI_HOME=/usr/lib64/openmpi
ENV NETCDF=/usr
ENV NETCDFF=/usr/local/netcdf-fortran
ENV IOAPI=/usr/local/ioapi
ENV LD_LIBRARY_PATH=/usr/lib64/openmpi/lib:/usr/local/netcdf-fortran/lib:/usr/local/ioapi/lib
ENV PATH=/usr/lib64/openmpi/bin:$PATH

WORKDIR /opt/cmaq
CMD ["bash"]
