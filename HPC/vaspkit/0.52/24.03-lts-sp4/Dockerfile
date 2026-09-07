ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=0.52
ARG VASPKIT_URL=https://sourceforge.net/projects/vaspkit/files/Src/vaspkit.${VERSION}.tar.gz

RUN yum install -y \
        gcc gcc-c++ gfortran make wget tar && \
    yum clean all && rm -rf /var/cache/yum

RUN wget ${VASPKIT_URL} -O /tmp/vaspkit.tar.gz && \
    mkdir -p /opt/vaspkit && \
    tar -xzf /tmp/vaspkit.tar.gz -C /opt/vaspkit --strip-components=1 && \
    rm -f /tmp/vaspkit.tar.gz && \
    cd /opt/vaspkit && \
    make -j$(nproc) && \
    cp bin/vaspkit /usr/local/bin/ && \
    rm -rf /opt/vaspkit

WORKDIR /workspace
CMD ["/bin/bash"]