ARG BASE=openeuler/python:3.11.13-oe2403lts
ARG VERSION=v1.4

FROM $BASE

RUN yum update -y && \
    yum install -y \
        mesa-libGL \
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
    cp -r GenAIComps/comps /home/user/comps && \
    rm -rf GenAIComps


RUN pip install --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir -r /home/user/comps/llms/src/text-generation/requirements.txt

ENV PYTHONPATH=$PYTHONPATH:/home/user

USER user

WORKDIR /home/user/comps/llms/src/text-generation

ENTRYPOINT ["bash", "entrypoint.sh"]