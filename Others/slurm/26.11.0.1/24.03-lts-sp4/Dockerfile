ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)
ARG VERSION=26.11.0.1
ARG TAG=slurm-26-11-0-1
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
