ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE
ARG VERSION=0.4.09
ARG TARGETARCH
RUN yum install -y \
        git which curl bzip2 jq \
        gcc gcc-c++ gcc-gfortran \
        zlib-devel openssl-devel libcurl-devel && \
    yum clean all && rm -rf /var/cache/yum
RUN CONDA_ARCH=x86_64; \
    if [ "$TARGETARCH" = "arm64" ]; then CONDA_ARCH=aarch64; fi && \
    curl -L https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-${CONDA_ARCH}.sh -o /tmp/miniforge.sh && \
    bash /tmp/miniforge.sh -b -p /opt/conda && \
    rm /tmp/miniforge.sh && \
    /opt/conda/bin/conda create -n wgcna -c conda-forge -c bioconda \
        r-base=4.4 r-seurat r-hdf5r r-wgcna r-igraph r-tidyverse \
        r-ggraph r-harmony r-enrichr r-devtools r-proxy \
        bioconductor-ucell bioconductor-genomicranges bioconductor-geneoverlap && \
    /opt/conda/bin/conda clean -afy
ENV PATH=/opt/conda/envs/wgcna/bin:$PATH
RUN R -e "install.packages(c('tester'), repos='https://cloud.r-project.org/')"
RUN git clone -b v${VERSION} https://github.com/smorabit/hdWGCNA.git /wgcna && \
    R CMD INSTALL /wgcna && \
    rm -rf /wgcna
WORKDIR /workspace
CMD ["/bin/bash"]