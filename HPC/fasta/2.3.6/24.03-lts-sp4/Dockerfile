ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE
ARG VERSION=2.3.6
RUN yum install -y \
        python3 python3-pip git \
        gcc gcc-c++ make openblas-devel && \
    yum clean all && rm -rf /var/cache/yum
RUN git clone -b ${VERSION} https://github.com/xapple/fasta.git /opt/fasta && \
    cd /opt/fasta && \
    pip3 install --no-cache-dir . && \
    rm -rf /opt/fasta/.git
WORKDIR /workspace
CMD ["/bin/bash"]