ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE
ARG VERSION=0.4.09
RUN yum install -y \
        git which curl bzip2 \
        gcc gcc-c++ gcc-gfortran \
        zlib-devel openssl-devel libcurl-devel && \
    yum clean all && rm -rf /var/cache/yum
RUN curl -L https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-aarch64.sh -o /tmp/miniforge.sh && \
    bash /tmp/miniforge.sh -b -p /opt/conda && \
    rm /tmp/miniforge.sh && \
    /opt/conda/bin/conda create -n hdWGCNA -c conda-forge -c bioconda \
        r-base=4.4 r-seurat r-hdf5r r-wgcna r-igraph r-tidyverse \
        r-ggraph r-harmony r-enrichr r-devtools r-proxy \
        bioconductor-ucell bioconductor-genomicranges bioconductor-geneoverlap && \
    /opt/conda/bin/conda clean -afy
ENV PATH=/opt/conda/envs/hdWGCNA/bin:$PATH
RUN R -e "install.packages(c('tester'), repos='https://cloud.r-project.org/')"
RUN git clone -b v${VERSION} https://github.com/smorabit/hdWGCNA.git /hdWGCNA && \
    R CMD INSTALL /hdWGCNA && \
    rm -rf /hdWGCNA
WORKDIR /workspace
CMD ["/bin/bash"]