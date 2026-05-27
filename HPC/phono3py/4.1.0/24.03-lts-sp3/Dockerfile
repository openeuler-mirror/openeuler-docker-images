ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE
ARG VERSION=4.1.0
ARG TAG=v${VERSION}
RUN yum install -y \
        gcc gcc-c++ make cmake git \
        python3 python3-pip python3-devel \
        openblas-devel libgomp && \
    yum clean all && rm -rf /var/cache/yum
RUN pip3 install --no-cache-dir phonopy && \
    git clone -b ${TAG} --depth=1 https://github.com/phonopy/phono3py.git /phono3py && \
    cd /phono3py && \
    USE_CONDA_PATH=OFF pip3 install --no-cache-dir . && \
    rm -rf /phono3py
WORKDIR /workspace
CMD ["/bin/bash"]