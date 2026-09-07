ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG TARGETARCH
ARG KOBAS_VERSION=3.0.3

WORKDIR /opt/kobas

RUN dnf install -y wget tar gcc gcc-c++ make perl grep findutils patch && \
    dnf clean all && \
    rm -rf /var/cache/dnf

# Install Miniconda as the base runtime/environment manager.
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BUILDARCH="aarch64"; \
    else \
        echo "Unsupported architecture: $TARGETARCH"; exit 1; \
    fi; \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-${BUILDARCH}.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm -f /tmp/miniconda.sh

# Accept the Anaconda TOS and tune network retries/timeouts to avoid
# intermittent downloads from anaconda.org channels.
RUN /opt/conda/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    /opt/conda/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r && \
    /opt/conda/bin/conda config --set remote_connect_timeout_secs 120 && \
    /opt/conda/bin/conda config --set remote_read_timeout_secs 120 && \
    /opt/conda/bin/conda config --set remote_max_retries 5

# Create the kobas environment with Python 3.
RUN /opt/conda/bin/conda create -y -n kobas python=3 \
    && /opt/conda/bin/conda clean -a -y

SHELL ["/opt/conda/bin/conda", "run", "-n", "kobas", "/bin/bash", "-c"]

# KOBAS and its dependencies are all installed from conda channels:
# pandas, BLAST, R, rpy2, biopython and the bioconda qvalue package.
# Retry the whole install because this host has flaky connectivity to
# anaconda.org and downloads can die mid-stream.
RUN ok=0; \
    for i in $(seq 1 8); do \
        if /opt/conda/bin/conda install -y -n kobas -c conda-forge -c bioconda \
            pandas \
            blast \
            r-base \
            rpy2 \
            biopython \
            bioconductor-qvalue; then \
            ok=1; \
            break; \
        fi; \
        echo "conda install attempt $i failed, retrying..."; \
        sleep 15; \
    done; \
    if [ "$ok" != "1" ]; then \
        echo "conda install failed after 8 attempts"; \
        exit 1; \
    fi; \
    /opt/conda/bin/conda clean -a -y

# Download and install the KOBAS ${KOBAS_VERSION} noarch (py_3) conda package.
# NOTE: the "-py_3" suffix is only the conda build number, not a Python 3
# build -- the package actually ships Python 2 code (it declares "python <3"
# and KOBAS 3.0.3 predates Python 3). The Python 3 environment created above
# is kept, and kobas-py3.patch (a 2to3-based conversion plus a few manual
# fixes) is applied to make the installed code run under Python 3.
RUN wget "https://anaconda.org/bioconda/kobas/${KOBAS_VERSION}/download/noarch/kobas-${KOBAS_VERSION}-py_3.tar.bz2" -O /tmp/kobas.tar.bz2 \
    && /opt/conda/bin/conda install -y -n kobas /tmp/kobas.tar.bz2 \
    && rm -f /tmp/kobas.tar.bz2 \
    && /opt/conda/bin/conda clean -a -y

COPY kobas-py3.patch /tmp/kobas-py3.patch

RUN SP=$(python -c 'import site; print(site.getsitepackages()[0])') \
    && patch -d "$SP" -p1 < /tmp/kobas-py3.patch \
    && rm -f /tmp/kobas-py3.patch \
    && python -m compileall -q "$SP/kobas" \
    && /opt/conda/bin/conda clean -a -y

FROM ${BASE}

COPY --from=builder /opt/conda /opt/conda

ENV PATH=/opt/conda/envs/kobas/bin:/opt/conda/bin:${PATH}
ENV LD_LIBRARY_PATH=/opt/conda/envs/kobas/lib:${LD_LIBRARY_PATH}

CMD ["kobas-annotate", "-h"]