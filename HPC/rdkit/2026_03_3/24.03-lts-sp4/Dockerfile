ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=2026_03_3

RUN dnf install -y \
      gcc gcc-c++ make \
      curl wget git \
      libX11-devel libXext-devel libXrender-devel \
      cairo-devel && \
    dnf clean all

RUN if [ "${TARGETARCH}" = "arm64" ]; then \
        ARCH=aarch64; \
    elif [ "${TARGETARCH}" = "amd64" ]; then \
        ARCH=x86_64; \
    fi; \
    curl -fSL -o /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-${ARCH}.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm -f /tmp/miniconda.sh

ENV PATH=/opt/conda/bin:$PATH

RUN CONDA_VERSION=$(echo ${VERSION} | tr '_' '.') && \
    conda install -c conda-forge --override-channels rdkit==${CONDA_VERSION} -y && \
    conda clean -afy

ENV RDBASE=/opt/conda
