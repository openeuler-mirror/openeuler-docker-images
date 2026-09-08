ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
ARG TARGETARCH
ARG VERSION=3.0.3

RUN dnf install -y wget tar gcc gcc-c++ make perl grep findutils patch && \
    dnf clean all && \
    rm -rf /var/cache/dnf

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

RUN echo '. /opt/conda/etc/profile.d/conda.sh' >> /root/.bashrc

SHELL ["/bin/bash", "-lc"]

RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

RUN conda create -y -n kobas && \
    conda clean -a -y
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        conda install -y -n kobas -c conda-forge -c bioconda kobas; \
    else \
        conda install -y -n kobas -c conda-forge -c bioconda python==2.7.15 && \
        conda install -y -n kobas -c conda-forge -c bioconda pandas && \
        conda activate kobas && pip install --no-cache-dir \
            flask==1.1.4 \
            jinja2==2.11.3 \
            werkzeug==1.0.1 \
            click==7.1.2 \
            itsdangerous==1.1.0 \
            markupsafe==1.1.1 \
            blast==0.3.0 && \
        conda install -y -n kobas -c conda-forge -c bioconda r-base && \
        dnf install -y glibc-devel && \
        cp /usr/include/crypt.h /opt/conda/envs/kobas/include/crypt.h && \
        dnf clean all && rm -rf /var/cache/dnf && \
        conda activate kobas && pip install --no-cache-dir \
            rpy2==2.8.5 \
            biopython==1.75 \
            singledispatch==3.7.0 && \
        conda install -y -n kobas -c conda-forge -c bioconda bioconductor-qvalue && \
        wget "https://anaconda.org/bioconda/kobas/${VERSION}/download/noarch/kobas-${VERSION}-py_3.tar.bz2" -O /tmp/kobas.tar.bz2 && \
        conda install -y -n kobas /tmp/kobas.tar.bz2 && \
        rm -f /tmp/kobas.tar.bz2; \
    fi && \
    conda clean -a -y

RUN conda run -n kobas kobas-annotate -h && \
    conda run -n kobas kobas-identify -h && \
    conda run -n kobas kobas-run -h

ENV PATH=/opt/conda/envs/kobas/bin:${PATH}

WORKDIR /workspace
CMD ["/bin/bash"]