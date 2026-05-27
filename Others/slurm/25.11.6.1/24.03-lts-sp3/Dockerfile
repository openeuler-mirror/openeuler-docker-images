ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE
ARG VERSION=25.11.6
ARG TAG=slurm-25-11-6-1
RUN yum install -y \
        git gcc gcc-c++ make \
        autoconf automake libtool pkg-config \
        hwloc-devel lua-devel readline-devel ncurses-devel \
        munge munge-devel \
        mariadb-devel \
        libcurl-devel json-c-devel && \
    yum clean all && rm -rf /var/cache/yum
RUN git clone -b ${TAG} https://github.com/SchedMD/slurm.git /slurm
WORKDIR /slurm
RUN ./configure --prefix=/usr --sysconfdir=/etc/slurm \
        --with-munge=/usr \
        --with-hwloc=/usr \
        --with-lua && \
    make -j $(nproc) && \
    make install
RUN mkdir -p /etc/slurm /var/log/slurm /var/spool/slurmctld /var/spool/slurmd
WORKDIR /workspace
CMD ["/bin/bash"]