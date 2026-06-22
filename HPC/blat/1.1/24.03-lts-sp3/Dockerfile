ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE
ARG VERSION=1.1
RUN yum install -y \
        git gcc gcc-c++ make which \
        zlib-devel openssl-devel \
        openmpi-devel && \
    yum clean all && rm -rf /var/cache/yum
RUN git clone -b ${VERSION} https://github.com/icebert/pblat-cluster.git /blat-cluster
WORKDIR /blat-cluster
RUN sed -i 's/MACHTYPE=x86_64/MACHTYPE=aarch64/g' Makefile && \
    sed -i 's/CFLAGS=-O -Wall/CFLAGS=-O -Wall -fcommon/g' Makefile && \
    sed -i 's/x86_64/aarch64/g' htslib/Makefile && \
    sed -i 's/if (format != NULL && args != NULL)/if (format != NULL)/g' lib/htmshell.c && \
    make -j $(nproc) && \
    cp pblat-cluster /usr/bin/blat
ENV PATH=/usr/lib64/openmpi/bin:$PATH
WORKDIR /workspace
CMD ["/bin/bash"]