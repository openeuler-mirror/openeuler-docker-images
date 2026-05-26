ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE
ARG VERSION=v2.0.0-a.7.1
RUN yum install -y \
        git gcc gcc-c++ make which \
        zlib-devel gmp-devel libzstd-devel openblas-devel && \
    yum clean all && rm -rf /var/cache/yum
RUN git clone -b ${VERSION} https://github.com/chrchang/plink-ng.git /plink-ng
RUN ln -sf /usr/include/openblas/* /usr/include/
WORKDIR /plink-ng/2.0
RUN sed -i 's/-llapack -lf77blas -latlas/-lopenblas -lgmp/g' Makefile && \
    make -j $(nproc) && \
    cp bin/plink2 /usr/bin/
WORKDIR /workspace
CMD ["/bin/bash"]