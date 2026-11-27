ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=1.44.0
ARG TARGETARCH

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
    /opt/conda/bin/conda create -y -n genomation -c conda-forge \
        r-base=4.6.2 \
        compilers \
        zlib \
        bzip2 \
        xz \
        libxml2-devel && \
    /opt/conda/bin/conda clean -afy

ENV PATH=/opt/conda/envs/genomation/bin:$PATH

RUN R -e "options(timeout=1200); install.packages('BiocManager', repos='https://cloud.r-project.org/')" && \
    R -e "options(timeout=1200, repos=c(CRAN='https://cloud.r-project.org/')); BiocManager::install(version='3.23', update=TRUE, ask=FALSE)" && \
    R -e "options(timeout=1200, repos=c(CRAN='https://cloud.r-project.org/')); BiocManager::install('genomation', version='3.23', update=FALSE, ask=FALSE)" && \
    R -e "stopifnot(as.character(packageVersion('genomation')) == '${VERSION}')"

FROM ${BASE}

COPY --from=builder /opt/conda /opt/conda

ENV PATH=/opt/conda/envs/genomation/bin:$PATH

WORKDIR /workspace
USER root
CMD ["/bin/bash"]
