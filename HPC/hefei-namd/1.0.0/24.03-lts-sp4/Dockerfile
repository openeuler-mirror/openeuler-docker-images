ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

RUN dnf update -y \
    && dnf install -y gcc-gfortran make git python3-pip fftw-devel findutils \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN pip3 install numpy scipy

WORKDIR /opt

RUN git clone https://github.com/QijingZheng/vaspwfc.git \
    && cd vaspwfc \
    && sed -i 's/FC= ifort -assume byterecl/FC= gfortran/' Makefile \
    && sed -i 's/FC= gfortran -lfftw3/FC= gfortran/' Makefile \
    && sed -i 's/FC= gfortran/FC= gfortran -lfftw3/' Makefile \
    && make wfc \
    && make gam

RUN git clone https://github.com/QijingZheng/Hefei-NAMD.git \
    && cd Hefei-NAMD/src/namd \
    && sed -i 's/FC= ifort -assume byterecl/#FC= ifort -assume byterecl/' Makefile \
    && sed -i 's/#FC= gfortran/FC= gfortran/' Makefile \
    && sed -i 's/FFLAGS= -g -O2/FFLAGS= -g -O2 -ffree-line-length-none/' Makefile \
    && make tdm \
    && cd ../namdK \
    && sed -i 's/FC= ifort -assume byterecl/#FC= ifort -assume byterecl/' Makefile \
    && sed -i 's/#FC= gfortran/FC= gfortran/' Makefile \
    && sed -i 's/FFLAGS= -g -O2  -check bounds -g -traceback/FFLAGS= -g -O2 -ffree-line-length-none/' Makefile \
    && make tdm \
    && cd ../dish \
    && sed -i 's/FC= ifort -assume byterecl/#FC= ifort -assume byterecl/' Makefile \
    && sed -i 's/#FC= gfortran/FC= gfortran/' Makefile \
    && sed -i 's/FFLAGS= -g -O3/FFLAGS= -g -O3 -ffree-line-length-none/' Makefile \
    && make tdm

FROM ${BASE}

RUN dnf update -y \
    && dnf install -y python3-pip fftw \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN pip3 install numpy scipy

COPY --from=builder /opt/vaspwfc/vaspwfc /usr/local/bin/
COPY --from=builder /opt/vaspwfc/vaspwfc_gam /usr/local/bin/
COPY --from=builder /opt/Hefei-NAMD/src/namd/namd /usr/local/bin/
COPY --from=builder /opt/Hefei-NAMD/src/namdK/namdk /usr/local/bin/
COPY --from=builder /opt/Hefei-NAMD/src/dish/dish /usr/local/bin/
COPY --from=builder /opt/Hefei-NAMD/scripts /opt/Hefei-NAMD/scripts

WORKDIR /opt/Hefei-NAMD

CMD ["bash"]