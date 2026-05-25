ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE
ARG VERSION=v1.2.7
RUN yum install -y \
        git gcc gcc-c++ make which \
        boost-devel && \
    yum clean all && rm -rf /var/cache/yum
RUN git clone -b ${VERSION} https://github.com/ccsb-scripps/AutoDock-Vina.git /autodock-vina
WORKDIR /autodock-vina/build/linux/release
RUN sed -i 's/-static //g' Makefile && \
    make -j $(nproc) && \
    cp vina /usr/bin/ && \
    cp vina_split /usr/bin/
WORKDIR /workspace
CMD ["/bin/bash"]