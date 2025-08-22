ARG BASE=openeuler/python:3.11.13-oe2403lts
ARG VERSION=v1.3

FROM $BASE

RUN yum update -y && \
    yum install -y \
        git && \
    yum clean all 

ARG VERSION
ARG GENAICOMPS_REPO=https://github.com/opea-project/GenAIComps.git
RUN git clone -b $VERSION $GENAICOMPS_REPO && \
    cp -r GenAIComps/comps /home/comps && \
    rm -rf GenAIComps

RUN pip install --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir -r /home/comps/embeddings/src/requirements.txt

ENV PYTHONPATH=$PYTHONPATH:/home

WORKDIR /home/comps/embeddings/src/

ENV MULTIMODAL_EMBEDDING="false"

ENTRYPOINT ["sh", "-c", "python $( [ \"$MULTIMODAL_EMBEDDING\" = \"true\" ] && echo 'opea_multimodal_embedding_microservice.py' || echo 'opea_embedding_microservice.py')"]