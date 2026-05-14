ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG FAISS_VERSION=1.14.1

RUN if [ "${TARGETARCH}" = "arm64" ]; then ARCH=aarch64; elif [ "${TARGETARCH}" = "amd64" ]; then ARCH=x86_64; else ARCH=${TARGETARCH}; fi && \
    curl -fSL -o /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-${ARCH}.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh

ENV PATH=/opt/conda/bin:$PATH

RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r && \
    conda install -y python=3.12 pytorch::faiss-cpu=${FAISS_VERSION} && \
    conda clean -afy

WORKDIR /workspace

CMD ["python3"]
