ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=3.0.3


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


RUN /opt/conda/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main \
    && /opt/conda/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r \
    && /opt/conda/bin/conda config --add channels bioconda \
    && /opt/conda/bin/conda config --add channels conda-forge \
    && /opt/conda/bin/conda create -y -n kobas python=2.7.15 r-base rpy2>=2.7.0 blast numpy pandas biopython sqlite bioconductor-qvalue \
    && /opt/conda/bin/conda clean -a -y

SHELL ["/opt/conda/bin/conda", "run", "-n", "kobas", "/bin/bash", "-c"]
RUN cd /tmp \
    && wget http://bioinfo.org/kobas/tcm/download/?file_path=/home/jingdu/JINGD/data/www/kobas-${VERSION}.tar.gz -O kobas.tar.gz \
    && tar -xzf kobas.tar.gz \
    && rm -f kobas.tar.gz \
    && pip install --no-cache-dir ./kobas-${VERSION} \
    && rm -rf ./kobas-${VERSION}

ENV PATH=/opt/conda/envs/kobas/bin:$PATH

CMD ["kobas-annotate", "-h"]