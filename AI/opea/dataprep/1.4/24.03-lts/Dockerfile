ARG BASE=openeuler/python:3.11.13-oe2403lts
ARG VERSION=v1.4

FROM $BASE

ARG VERSION

ENV LANG=C.UTF-8

ARG ARCH="cpu"

RUN yum update -y && yum install -y \
    gcc g++ make cmake \
    java-1.8.0-openjdk \
    cairo \
    libxslt \
    mesa-libGL \
    jemalloc-devel \
    mariadb-connector-c-devel-3.3.8 \
    libpq-devel \
    poppler-utils \
    tesseract-tools \
    ffmpeg \
    wget curl \
    shadow \
    git && \
    yum clean all && \
    rm -rf /var/cache/yum

ENV TESSDATA_PREFIX=/usr/share/tesseract/tessdata

RUN LIBREOFFICE_URL=https://mirrors.tuna.tsinghua.edu.cn/libreoffice/libreoffice/stable/25.2.4/rpm/x86_64/LibreOffice_25.2.4_Linux_x86-64_rpm.tar.gz && \
    wget $LIBREOFFICE_URL -O /tmp/libreOffice.tar.gz && \
    tar --strip-components=1 -xvf /tmp/libreOffice.tar.gz -C /tmp && \
    yum install -y /tmp/RPMS/*.rpm && \
    yum clean all && \
    rm -fr /tmp/libreOffice.tar.gz /tmp/RPMS && \
    ln -sf /usr/bin/libreoffice25.2 /usr/bin/libreoffice

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

ARG GENAICOMPS_REPO=https://github.com/opea-project/GenAIComps.git
RUN git clone -b $VERSION $GENAICOMPS_REPO && \
    cp -r GenAIComps/comps /home/user/comps && \
    rm -rf GenAIComps

ARG uvpip='uv pip install --system --no-cache-dir'
RUN pip install --no-cache-dir --upgrade pip setuptools uv && \
    if [ ${ARCH} = "cpu" ]; then \
        PIP_EXTRA_INDEX_URL="--extra-index-url https://download.pytorch.org/whl/cpu"; \
    else \
        PIP_EXTRA_INDEX_URL=""; \
    fi && \
    $uvpip torch torchvision ${PIP_EXTRA_INDEX_URL} && \
    $uvpip -r /home/user/comps/dataprep/src/requirements.txt

ENV PYTHONPATH=$PYTHONPATH:/home/user

RUN mkdir -p /home/user/comps/dataprep/src/uploaded_files && chown -R user /home/user/comps/dataprep/src/uploaded_files
RUN mkdir -p /data && chown -R user /data

USER user
ENV NLTK_DATA=/home/user/nltk_data
# air gapped support: predownload all needed nltk data
RUN mkdir -p /home/user/nltk_data && python -m nltk.downloader -d /home/user/nltk_data punkt_tab averaged_perceptron_tagger_eng stopwords
# air gapped support: set model cache dir
ENV HF_HUB_CACHE=/data

WORKDIR /home/user/comps/dataprep/src

ENTRYPOINT ["sh", "-c", "python $( [ \"$MULTIMODAL_DATAPREP\" = \"true\" ] && echo 'opea_dataprep_multimodal_microservice.py' || echo 'opea_dataprep_microservice.py')"]