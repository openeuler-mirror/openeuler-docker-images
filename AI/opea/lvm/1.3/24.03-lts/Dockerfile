ARG BASE=openeuler/python:3.11.13-oe2403lts
ARG VERSION=v1.3

FROM $BASE

# Set this to "cpu" or "gpu" or etc
ARG ARCH="cpu"

RUN yum update -y && \
    yum install -y \
        git \
        shadow && \
    yum clean all 

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

ENV LANG=C.UTF-8

ARG VERSION
ARG GENAICOMPS_REPO=https://github.com/opea-project/GenAIComps.git
RUN git clone -b $VERSION $GENAICOMPS_REPO && \
    cp -r GenAIComps/comps /home/user/comps && \
    rm -rf GenAIComps

RUN pip install --no-cache-dir --upgrade pip setuptools && \
    if [ ${ARCH} = "cpu" ]; then \
      pip install --no-cache-dir --extra-index-url https://download.pytorch.org/whl/cpu -r /home/user/comps/lvms/src/requirements.txt; \
    else \
      pip install --no-cache-dir -r /home/user/comps/lvms/src/requirements.txt; \
    fi && \
    pip install --no-cache-dir --upgrade transformers

ENV PYTHONPATH=$PYTHONPATH:/home/user

USER user

WORKDIR /home/user/comps/lvms/src

ENTRYPOINT ["python", "opea_lvm_microservice.py"]