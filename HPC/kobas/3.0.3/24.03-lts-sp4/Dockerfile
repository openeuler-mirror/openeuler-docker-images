ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=3.0.3


RUN dnf update -y \
    && dnf install -y wget gcc gcc-c++ make \
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
    && /opt/conda/bin/conda config --set remote_connect_timeout_secs 120 \
    && /opt/conda/bin/conda config --set remote_read_timeout_secs 120 \
    && /opt/conda/bin/conda config --set remote_max_retries 5 \
    && /opt/conda/bin/conda create -y -n kobas python=2.7 \
    && /opt/conda/bin/conda install -y -n kobas blast \
    && /opt/conda/bin/conda clean -a -y

SHELL ["/opt/conda/bin/conda", "run", "-n", "kobas", "/bin/bash", "-c"]
# conda's rpy2/python2 build is unavailable, so the Python 2.7 compatible
# releases of the Python libraries are pip-installed instead.
# Install in stages so numpy is already present when pandas builds, otherwise
# pandas' setup_requires fetches an incompatible release to satisfy its dep.
# All versions below are pinned to Python 2.7 compatible releases; otherwise pip
# resolves the newest (Python 3 only) releases of the transitive deps.
RUN pip install --no-cache-dir "numpy==1.16.6" \
    && pip install --no-cache-dir "pandas==0.24.2" "python-dateutil==2.8.1" "pytz==2020.1" "six==1.15.0" \
    && pip install --no-cache-dir "biopython==1.76" \
    && pip install --no-cache-dir "rpy2==2.9.4"
# Install the Bioconductor qvalue package (used by KOBAS enrichment) via R
RUN R -e "install.packages('BiocManager', repos='https://cloud.r-project.org'); BiocManager::install('qvalue', ask=FALSE, update=FALSE, checkBuilt=TRUE)"
RUN cd /tmp \
    && wget http://bioinfo.org/kobas/tcm/download/?file_path=/home/jingdu/JINGD/data/www/kobas-${VERSION}.tar.gz -O kobas.tar.gz \
    && tar -xzf kobas.tar.gz \
    && rm -f kobas.tar.gz \
    && pip install --no-cache-dir ./kobas-${VERSION} \
    && rm -rf ./kobas-${VERSION}

ENV PATH=/opt/conda/envs/kobas/bin:$PATH

CMD ["kobas-annotate", "-h"]