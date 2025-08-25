ARG BASE=openeuler/python:3.11.13-oe2403lts
ARG VERSION=v1.4

FROM $BASE

ARG ARCH="cpu"

RUN yum update -y && \
    yum install -y \
        cairo \
        mesa-libGL \
        glib2 \
        jemalloc-devel \
        shadow \
        git && \
    yum clean all

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

ARG VERSION
ARG GENAICOMPS_REPO=https://github.com/opea-project/GenAIComps.git
RUN git clone -b $VERSION $GENAICOMPS_REPO && \
    mkdir -p /home/user && \
    cp -r GenAIComps/comps /home/user/comps && \
    rm -rf GenAIComps

ARG uvpip='uv pip install --system --no-cache-dir'
RUN pip install --no-cache-dir --upgrade pip setuptools uv && \
    if [ ${ARCH} = "cpu" ]; then \
      $uvpip torch torchvision --index-url https://download.pytorch.org/whl/cpu; \
      $uvpip -r /home/user/comps/retrievers/src/requirements-cpu.txt; \
    else \
      $uvpip -r /home/user/comps/retrievers/src/requirements-gpu.txt; \
    fi

ENV PYTHONPATH=$PYTHONPATH:/home/user

USER user
ENV NLTK_DATA=/home/user/nltk_data

WORKDIR /home/user/comps/retrievers/src

ENTRYPOINT ["python", "opea_retrievers_microservice.py"]