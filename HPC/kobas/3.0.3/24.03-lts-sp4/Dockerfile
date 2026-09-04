ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=3.0.3

# KOBAS 3.0 requires Python 2 which is not shipped by openEuler 24.03,
# so Miniconda is used to create a Python 2.7 runtime environment.
RUN dnf update -y \
    && dnf install -y wget \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN if [ "$TARGETARCH" = "amd64" ]; then \
        BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BUILDARCH="aarch64"; \
    else \
        echo "Unsupported architecture: $TARGETARCH" && exit 1; \
    fi; \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-${BUILDARCH}.sh -O /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -b -p /opt/conda \
    && rm -f /tmp/miniconda.sh

# Accept the Anaconda Terms of Service non-interactively (matches the pattern
# used by other HPC images, e.g. meep) so conda create below won't prompt.
RUN /opt/conda/bin/conda tos accept \
    && /opt/conda/bin/conda config --add channels bioconda \
    && /opt/conda/bin/conda config --add channels conda-forge \
    && /opt/conda/bin/conda create -y -n kobas python=2.7 r-base rpy2>=2.8.5 blast numpy pandas biopython sqlite bioconductor-qvalue \
    && /opt/conda/bin/conda clean -a -y

# Download and source-build install KOBAS ${VERSION} into the conda env
SHELL ["/opt/conda/bin/conda", "run", "-n", "kobas", "/bin/bash", "-c"]
RUN cd /tmp \
    && wget http://kobas.cbi.pku.edu.cn/kobas-2.1.1/kobas-${VERSION}.tar.gz -O kobas.tar.gz \
    && tar -xzf kobas.tar.gz \
    && rm -f kobas.tar.gz \
    && pip install --no-cache-dir ./kobas-${VERSION} \
    && rm -rf ./kobas-${VERSION}

ENV PATH=/opt/conda/envs/kobas/bin:$PATH

CMD ["kobas-annotate", "-h"]