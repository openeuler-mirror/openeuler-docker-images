ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE
ARG VERSION=1.1.1
RUN yum install -y \
        git python3 python3-pip which && \
    yum clean all && rm -rf /var/cache/yum
RUN git clone -b v${VERSION} https://github.com/spack/spack.git /spack
ENV PATH=/spack/bin:${PATH}
WORKDIR /workspace
CMD ["/bin/bash"]