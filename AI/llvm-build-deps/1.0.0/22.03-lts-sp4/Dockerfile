ARG BASE=openeuler/openeuler:22.03-lts-sp4
FROM ${BASE}

RUN yum update -y && \
    yum install -y \
        gcc \
        g++ \
        make \
        cmake \
        openssl-devel \
        binutils-devel \
        python3 \
        python3-setuptools \
        python-wheel \
        texinfo \
        libatomic && \
    yum clean all

CMD ["bash"]
