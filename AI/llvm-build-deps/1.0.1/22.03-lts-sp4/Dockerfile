ARG BASE=openeuler/openeuler:22.03-lts-sp4
FROM ${BASE}

RUN yum update -y && \
    yum install -y \
        gcc \
        g++ \
        libgcc \
        binutils \
        binutils-devel \
        make \
        cmake \
        openssl-devel \
        python3 \
        python3-setuptools \
        python3-devel \
        python-wheel \
        texinfo \
        libstdc++-static \
        libasan \
        libubsan \
        liblsan \
        libzstd-devel \
        ncurses-devel \
        libatomic && \
    yum clean all

CMD ["bash"]
