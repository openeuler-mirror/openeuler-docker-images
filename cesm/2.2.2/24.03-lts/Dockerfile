ARG BASE=openeuler/openeuler:24.03-lts
FROM ${BASE}

ARG VERSION=2.2.2

RUN yum update -y && \
    yum install -y libcurl-devel m4 zlib-devel git perl make gcc g++ gfortran wget && \
    ln -sf /usr/bin/python3 /usr/bin/python

WORKDIR /tmp/sources

# Install all dependecy
RUN wget -O mpich-3.3.2.tar.gz http://www.mpich.org/static/downloads/3.3.2/mpich-3.3.2.tar.gz && \
    tar zxf mpich-3.3.2.tar.gz && \
    cd mpich-3.3.2 && \
    ./configure \
        --prefix=/usr/local \
        FFLAGS="-w -fallow-argument-mismatch -O2" && \
    make -j "$(nproc)" install
RUN wget -O hdf5-1.12.0.tar.gz https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.0/src/hdf5-1.12.0.tar.gz && \
    tar zxf hdf5-1.12.0.tar.gz && \
    cd hdf5-1.12.0 && \
    ./configure --prefix=/usr/local && \
    make -j "$(nproc)" install
RUN wget -O netcdf-c.tar.gz https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.7.4.tar.gz && \
    mkdir -p netcdf-c && tar vxf netcdf-c.tar.gz -C netcdf-c --strip-components=1 && \
    cd netcdf-c && ./configure --prefix=/usr/local && \
    make -j "$(nproc)" install && \
    ldconfig
RUN wget -O netcdf-fortran.tar.gz https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.5.3.tar.gz && \
    mkdir netcdf-fortran && tar -zvxf netcdf-fortran.tar.gz -C netcdf-fortran --strip-components=1 && \
    cd netcdf-fortran && \
    LDFLAGS="-L/usr/local/lib" \
    CPPFLAGS="-I/usr/local/include" \
    LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH} \
    ./configure --prefix=/usr/local && \
    make -j "$(nproc)" install && \
    ldconfig
RUN wget -O pnetcdf-1.12.1.tar.gz https://parallel-netcdf.github.io/Release/pnetcdf-1.12.1.tar.gz && \
    tar zxf pnetcdf-1.12.1.tar.gz && \
    cd pnetcdf-1.12.1 && \
    ./configure \
        --prefix=/usr/local \
        FCFLAGS="-w -fallow-argument-mismatch -O2" \
        FFLAGS="-w -fallow-argument-mismatch -O2" && \
    make -j "$(nproc)" install && \
    ldconfig && \
    rm -rf /tmp/sources

# Install cesm2
WORKDIR /opt/ncar
RUN yum install -y subversion cmake lapack-devel blas-devel perl-XML-LibXML && \
    git clone -b release-cesm${VERSION} https://github.com/ESCOMP/cesm.git cesm2 && \
    cd cesm2 && \
    ./manage_externals/checkout_externals 

# Set up the environment - create the group and user, the shell variables, the input data directory and access:
RUN echo 'export CESMDATAROOT=${HOME}' | tee /etc/profile.d/escomp.sh && \
    echo 'export CIME_MACHINE=container' | tee -a /etc/profile.d/escomp.sh && \
    echo 'export USER=$(whoami)' | tee -a /etc/profile.d/escomp.sh && \
    echo 'export PS1="[\u@cesm \W]\$ "' | tee -a /etc/profile.d/escomp.sh && \
    echo 'ulimit -s unlimited' | tee -a /etc/profile.d/escomp.sh && \
    echo 'export PATH=${PATH}:/opt/ncar/cesm2/cime/scripts' | tee -a /etc/profile.d/escomp.sh

# Get config files
RUN git clone https://github.com/ESCOMP/ESCOMP-Containers.git /containers && \
    cp -rf /containers/CESM/2.2/Files/config_machines.xml /opt/ncar/cesm2/cime/config/cesm/machines/ && \
    cp -rf /containers/CESM/2.2/Files/config_inputdata.xml /opt/ncar/cesm2/cime/config/cesm/ && \
    cp -rf /containers/CESM/2.2/Files/case_setup.py /opt/ncar/cesm2/cime/scripts/lib/CIME/case/case_setup.py && \
    cp -rf /containers/CESM/2.2/Files/config_compsets.xml /opt/ncar/cesm2/cime_config/ && \
    cp -rf /containers/CESM/2.2/Files/config_pes.xml /opt/ncar/cesm2/cime_config/ && \
    cp -rf /containers/CESM/2.2/Files/configs/cam/config_pes.xml /opt/ncar/cesm2/components/cam/cime_config/ && \
    cp -rf /containers/CESM/2.2/Files/configs/cice/config_pes.xml /opt/ncar/cesm2/components/cice/cime_config/ && \
    cp -rf /containers/CESM/2.2/Files/configs/cism/config_pes.xml /opt/ncar/cesm2/components/cism/cime_config/ && \
    cp -rf /containers/CESM/2.2/Files/configs/pop/config_pes.xml /opt/ncar/cesm2/components/pop/cime_config/ && \
    cp -rf /containers/CESM/2.2/Files/configs/clm/config_pes.xml /opt/ncar/cesm2/components/clm/cime_config/ && \
    cp -rf /containers/CESM/2.2/Files/micro_mg3_0.F90 /opt/ncar/cesm2/components/cam/src/physics/pumas/micro_mg3_0.F90 && \
    cp -rf /containers/CESM/2.2/Files/scam_shell_commands /opt/ncar/cesm2/components/cam/cime_config/usermods_dirs/scam_mandatory/shell_commands && \
    cp -rf /containers/CESM/2.2/Files/create_scam6_iop /opt/ncar/cesm2/components/cam/bld/scripts && \
    rm -rf /containers

COPY config_compilers.xml /opt/ncar/cesm2/cime/config/cesm/machines/

ENV CESMROOT=/opt/ncar/cesm2 

CMD ["/bin/bash", "-l"]