ARG IMAGE_NAME=openeuler/python
ARG IMAGE_TAG=3.11.13-oe2403lts
ARG VERSION=v1.3

FROM ${IMAGE_NAME}:${IMAGE_TAG} AS base

ARG VERSION
ENV HOME=/home/user

RUN yum update -y && \
    yum install -y shadow git && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN useradd -m -s /bin/bash user && \
    mkdir -p $HOME && \
    chown -R user $HOME

WORKDIR $HOME

ARG GENAICOMPS_REPO=https://github.com/opea-project/GenAIComps.git
RUN git clone -b $VERSION $GENAICOMPS_REPO && \
    cp -r GenAIComps/*.toml ./ && \
    cp -r GenAIComps/*.py ./ && \
    cp -r GenAIComps/*.txt ./ && \
    cp -r GenAIComps/*.md ./ && \
    cp -r GenAIComps/LICENSE ./ && \
    cp -r GenAIComps/comps ./comps && \
    rm -rf GenAIComps


ARG uvpip='uv pip install --system --no-cache-dir'
RUN pip install --no-cache-dir --upgrade pip setuptools uv && \
    $uvpip -r requirements.txt

ENV PYTHONPATH=$PYTHONPATH:$HOME

USER user

ENTRYPOINT ["sh", "-c", "set && ls -la"]