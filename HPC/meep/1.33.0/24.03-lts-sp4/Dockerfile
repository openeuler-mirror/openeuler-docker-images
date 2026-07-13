ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE
ARG VERSION=1.33.0
ARG TARGETARCH
RUN yum install -y wget bzip2 && \
    yum clean all && rm -rf /var/cache/yum
RUN if [ "$TARGETARCH" = "amd64" ]; then ARCH=x86_64; elif [ "$TARGETARCH" = "arm64" ]; then ARCH=aarch64; else ARCH=$TARGETARCH; fi && \
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-${ARCH}.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh && \
    /opt/conda/bin/conda clean -a -y
ENV PATH=/opt/conda/bin:$PATH
RUN conda tos accept && \
    conda create -n mp -c conda-forge \
        pymeep=${VERSION}=mpi_mpich_* && \
    conda clean -a -y
ENV PATH=/opt/conda/envs/mp/bin:$PATH
ENV LD_LIBRARY_PATH=/opt/conda/envs/mp/lib
WORKDIR /workspace
CMD ["/bin/bash"]