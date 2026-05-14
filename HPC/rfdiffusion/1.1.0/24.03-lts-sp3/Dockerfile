ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG VERSION=1.1.0

ENV LANG=C.UTF-8 \
    RFDIFFUSION_HOME=/opt/RFdiffusion \
    PATH=/opt/RFdiffusion/scripts:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN dnf -y update && \
    dnf -y install --nodocs --setopt=install_weak_deps=False \
        git wget curl python3 python3-pip gcc gcc-c++ make cmake && \
    dnf clean all && rm -rf /var/cache/dnf

RUN pip3 install --no-cache-dir \
    torch --index-url https://download.pytorch.org/whl/cpu

RUN pip3 install --no-cache-dir \
    hydra-core \
    pyrsistent \
    omegaconf \
    pyparsing \
    scipy \
    seaborn \
    pandas \
    decorator==5.1.0

WORKDIR /opt

RUN git clone --depth 1 --branch v${VERSION} https://github.com/RosettaCommons/RFdiffusion.git ${RFDIFFUSION_HOME}

WORKDIR ${RFDIFFUSION_HOME}/env/SE3Transformer

RUN pip3 install --no-cache-dir -r requirements.txt && \
    python3 setup.py install

WORKDIR ${RFDIFFUSION_HOME}

RUN pip3 install --no-cache-dir -e .

RUN mkdir -p ${RFDIFFUSION_HOME}/models

LABEL org.opencontainers.image.title="rfdiffusion" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.description="RFdiffusion protein structure generation environment (CPU)"