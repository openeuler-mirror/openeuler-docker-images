ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE
ARG VERSION=0.30.2
RUN yum install -y \
        python3 python3-pip \
        gcc gcc-c++ cmake make git \
        hdf5-devel zlib-devel && \
    yum clean all && rm -rf /var/cache/yum
RUN pip3 install --no-cache-dir kb-python==${VERSION}
RUN kb compile all --overwrite --tmp /tmp/kb_compile
WORKDIR /workspace
CMD ["/bin/bash"]