ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=0.4.12
ARG TARGETARCH

RUN dnf install -y \
        git which curl bzip2 \
        gcc gcc-c++ gcc-gfortran \
        zlib-devel openssl-devel libcurl-devel && \
    dnf clean all && rm -rf /var/cache/dnf

RUN CONDA_ARCH=x86_64; \
    if [ "$TARGETARCH" = "arm64" ]; then CONDA_ARCH=aarch64; fi && \
    cd /tmp && \
    curl -fSL --connect-timeout 30 --retry 3 -O \
        https://github.com/conda-forge/miniforge/releases/download/26.3.2-3/Miniforge3-26.3.2-3-Linux-${CONDA_ARCH}.sh && \
    curl -fSL --connect-timeout 30 --retry 3 -O \
        https://github.com/conda-forge/miniforge/releases/download/26.3.2-3/Miniforge3-26.3.2-3-Linux-${CONDA_ARCH}.sh.sha256 && \
    sha256sum -c Miniforge3-26.3.2-3-Linux-${CONDA_ARCH}.sh.sha256 && \
    bash Miniforge3-26.3.2-3-Linux-${CONDA_ARCH}.sh -b -p /opt/conda && \
    rm -f Miniforge3-26.3.2-3-Linux-${CONDA_ARCH}.sh* && \
    /opt/conda/bin/conda create -n hdwgcna -c conda-forge -c bioconda \
        r-base=4.4 r-seurat r-hdf5r r-wgcna r-igraph r-tidyverse \
        r-ggraph r-harmony r-enrichr r-devtools r-proxy r-tester \
        bioconductor-ucell bioconductor-genomicranges bioconductor-geneoverlap \
        bioconductor-summarizedexperiment && \
    /opt/conda/bin/conda clean -afy

ENV PATH=/opt/conda/envs/hdwgcna/bin:$PATH

RUN git clone -b v${VERSION} https://github.com/smorabit/hdWGCNA.git /hdwgcna && \
    R CMD INSTALL /hdwgcna && \
    rm -rf /hdwgcna

FROM ${BASE}

COPY --from=builder /opt/conda /opt/conda

ENV PATH=/opt/conda/envs/hdwgcna/bin:$PATH

WORKDIR /workspace
USER root
CMD ["/bin/bash"]
