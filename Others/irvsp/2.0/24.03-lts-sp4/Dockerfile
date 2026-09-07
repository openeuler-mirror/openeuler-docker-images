ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
ARG VERSION=2.0
RUN yum install -y \
        gcc-gfortran gcc gcc-c++ make which wget tar \
        openblas-devel lapack-devel && \
    yum clean all && rm -rf /var/cache/yum

WORKDIR /opt
RUN wget -q https://github.com/zjwang11/irvsp/raw/master/src_irvsp_v2.tar.gz && \
    tar xzf src_irvsp_v2.tar.gz && \
    mv src_irvsp_v2_release /opt/irvsp && \
    rm -f src_irvsp_v2.tar.gz
WORKDIR /opt/irvsp
RUN sed -i \
        -e 's/^F90 * = *ifort/F90 = gfortran/' \
        -e 's/^LINKER * = *\$(F90)/LINKER = \$(F90)/' \
        -e 's/FLAGS * = *-g -traceback/FLAGS = -O2 -ffree-line-length-none -g/' \
        -e 's/-fpp -DIRVSPDATA/-cpp -DIRVSPDATA -ffree-line-length-none/' \
        -e 's/ifort -assume byterecl -c/\$(F90) -cpp -DIRVSPDATA -O2 -ffree-line-length-none -c/' \
        -e 's/\$(F90) -c -FR/\$(F90) -c -ffree-form -ffree-line-length-none/' \
        Makefile && \
    make -j "$(nproc)"
RUN cp /opt/irvsp/irvsp /usr/local/bin/irvsp

WORKDIR /opt
RUN wget -q https://github.com/zjwang11/irvsp/raw/master/src_trace_v2.tar.gz && \
    tar xzf src_trace_v2.tar.gz && \
    mv src_trace_v2 /opt/vasp2trace && \
    rm -f src_trace_v2.tar.gz
WORKDIR /opt/vasp2trace
RUN wget -q https://github.com/zjwang11/irvsp/raw/master/vasp2trace_gfortran.Makefile && \
    cp vasp2trace_gfortran.Makefile Makefile && \
    sed -i 's/FLAGS  =  -g/FLAGS  =  -O2 -g -ffree-line-length-none/' Makefile && \
    make -j "$(nproc)" && \
    cp vasp2trace /usr/local/bin/vasp2trace

ENV IRVSPDATA=/opt/irvsp
WORKDIR /workspace
CMD ["/bin/bash"]