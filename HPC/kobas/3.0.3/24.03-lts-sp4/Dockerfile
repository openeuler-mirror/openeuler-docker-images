ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG TARGETPLATFORM
ARG KOBAS_VERSION=3.0.3

WORKDIR /opt/kobas

RUN dnf install -y \
    sqlite sqlite-devel \
    python2 python2-devel \
    R R-devel \
    openssl-devel libpng-devel libxml2-devel libjpeg-devel \
    wget tar gcc make perl-core \
    ncbi-blast+ \
    git \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN curl -sO https://bootstrap.pypa.io/pip/2.7/get-pip.py && \
    python2 get-pip.py && \
    rm -f get-pip.py

RUN pip2 install pysqlite \
                 egenix-mx-base \
                 numpy \
                 pandas==0.20 \
                 rpy2==2.7.0

RUN wget http://biopython.org/DIST/biopython-1.44.tar.gz && \
    tar zxf biopython-1.44.tar.gz && \
    cd biopython-1.44 && \
    python2 setup.py install && \
    cd /opt/kobas && rm -rf biopython-1.44*

RUN Rscript -e "install.packages('BiocManager', repos='https://cran.r-project.org')" && \
    Rscript -e "library(BiocManager); \
                BiocManager::install(c('qvalue','Biobase','GSEABase','pathview', \
                                       'ComplexHeatmap','DESeq2','EDASeq','GO.db', \
                                       'ReportingTools','SPIA','biocGraph','safe', \
                                       'topGO','GSVA','gage'), \
                                     update=FALSE, ask=FALSE)"

RUN wget https://bioconductor.org/packages/3.14/bioc/src/contrib/Rgraphviz_2.38.0.tar.gz && \
    tar -xf Rgraphviz_2.38.0.tar.gz && \
    cd Rgraphviz && \
    R CMD INSTALL . && \
    cd /opt/kobas && rm -rf Rgraphviz*

RUN wget http://bioinfo.org/kobas/tcm/download/?file_path=/home/jingdu/JINGD/data/www/kobas-${KOBAS_VERSION}.tar.gz -O kobas.tar.gz \
    && tar -xzf kobas.tar.gz \
    && rm -f kobas.tar.gz \
    && python2 setup.py install \
    && rm -rf ./kobas-${KOBAS_VERSION}

ENV PYTHONPATH=/opt/kobas/kobas-${KOBAS_VERSION}
RUN echo "export KOBAS_HOME=/opt/kobas/kobas-${KOBAS_VERSION}" > /root/.kobasrc && \
    echo "export PATH=\$KOBAS_HOME/bin:\$PATH" >> /root/.kobasrc && \
    echo "source /root/.kobasrc" >> /root/.bashrc

FROM ${BASE}

COPY --from=builder /usr/local /usr/local
COPY --from=builder /opt/kobas /opt/kobas
COPY --from=builder /root/.kobasrc /root/.kobasrc
COPY --from=builder /root/.bashrc /root/.bashrc

ENV PYTHONPATH=/opt/kobas/kobas-${KOBAS_VERSION}
ENV KOBAS_HOME=/opt/kobas/kobas-${KOBAS_VERSION}
ENV PATH=${KOBAS_HOME}/bin:/usr/local/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}

WORKDIR /opt/kobas/kobas-${KOBAS_VERSION}

CMD ["/bin/bash"]