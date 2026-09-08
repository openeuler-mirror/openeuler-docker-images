ARG BASE=openeuler/miniconda:24.03-lts-sp4
FROM ${BASE}
ARG VERSION=3.0.3

RUN echo '. /opt/conda/etc/profile.d/conda.sh' >> /root/.bashrc

SHELL ["/bin/bash", "-lc"]

RUN conda create -y -n kobas && \
    conda install -y -n kobas -c conda-forge -c bioconda python==2.7.15 && \
    conda clean -a -y

RUN conda install -y -n kobas -c conda-forge -c bioconda pandas && \
    conda clean -a -y

RUN conda activate kobas && pip install --no-cache-dir \
    flask==1.1.4 \
    jinja2==2.11.3 \
    werkzeug==1.0.1 \
    click==7.1.2 \
    itsdangerous==1.1.0 \
    markupsafe==1.1.1 \
    blast==0.3.0

RUN conda install -y -n kobas -c conda-forge -c bioconda r-base && \
    conda clean -a -y


RUN dnf install -y glibc-devel && \
    dnf clean all && \
    rm -rf /var/cache/dnf

RUN conda activate kobas && pip install --no-cache-dir \
    rpy2==2.8.5 \
    biopython==1.75 \
    singledispatch==3.7.0

RUN conda install -y -n kobas -c conda-forge -c bioconda bioconductor-qvalue && \
    conda clean -a -y

RUN wget "https://anaconda.org/bioconda/kobas/${VERSION}/download/noarch/kobas-${VERSION}-py_3.tar.bz2" -O /tmp/kobas.tar.bz2 && \
    conda install -y -n kobas /tmp/kobas.tar.bz2 && \
    rm -f /tmp/kobas.tar.bz2 && \
    conda clean -a -y

RUN conda run -n kobas kobas-annotate -h && \
    conda run -n kobas kobas-identify -h && \
    conda run -n kobas kobas-run -h

ENV PATH=/opt/conda/envs/kobas/bin:${PATH}

WORKDIR /workspace
CMD ["/bin/bash"]