ARG BASE=openeuler/openeuler:24.03-lts-sp4
ARG VERSION=1.28.0

FROM ${BASE} AS builder

ARG VERSION
ARG TARGETARCH

RUN dnf install -y \
      make gcc gcc-c++ gcc-gfortran \
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
    /opt/conda/bin/conda create -n batchelor -c conda-forge -y \
        r-base=4.6.2 compilers zlib && \
    /opt/conda/bin/conda clean -afy

ENV PATH=/opt/conda/envs/batchelor/bin:$PATH
ENV VERSION=${VERSION}

RUN Rscript -e 'options(timeout = 1200); \
    if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager", repos = "https://cloud.r-project.org"); \
    BiocManager::install(version = "3.23", ask = FALSE, update = FALSE); \
    BiocManager::install("batchelor", version = "3.23", ask = FALSE, update = FALSE, Ncpus = 4); \
    stopifnot(as.character(packageVersion("batchelor")) == Sys.getenv("VERSION"))'

FROM ${BASE}

COPY --from=builder /opt/conda /opt/conda

ENV PATH=/opt/conda/envs/batchelor/bin:$PATH

WORKDIR /workspace
USER root
CMD ["/bin/bash"]
