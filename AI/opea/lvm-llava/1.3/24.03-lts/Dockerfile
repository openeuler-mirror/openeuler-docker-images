ARG BASE=openeuler/python:3.11.13-oe2403lts
ARG VERSION=v1.3

FROM $BASE

# Set this to "cpu" or "gpu" or etc
ARG ARCH="cpu"

RUN yum update -y && \
    yum install -y \
        shadow \
        curl \
        git && \
    yum clean all

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/


# Set environment variables
ENV LANG=en_US.UTF-8
ENV PYTHONPATH=/home/user:/usr/lib/habanalabs/:/optimum-habana

ARG VERSION
ARG GENAICOMPS_REPO=https://github.com/opea-project/GenAIComps.git
RUN git clone -b $VERSION $GENAICOMPS_REPO && \
    cp -r GenAIComps/comps /home/user/comps && \
    rm -rf GenAIComps

RUN pip install --no-cache-dir --upgrade pip setuptools && \
    if [ ${ARCH} = "cpu" ]; then \
      pip install --no-cache-dir --extra-index-url https://download.pytorch.org/whl/cpu -r /home/user/comps/third_parties/llava/src/requirements.txt; \
    else \
      pip install --no-cache-dir -r /home/user/comps/third_parties/llava/src/requirements.txt; \
    fi

ENV PYTHONPATH=$PYTHONPATH:/home/user

USER user
WORKDIR /home/user/comps/third_parties/llava/src

ENTRYPOINT ["python", "llava_server.py", "--device", "cpu"]