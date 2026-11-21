ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=1.16.0

RUN dnf install -y python3 python3-pip && \
    dnf clean all && rm -rf /var/cache/dnf

RUN pip3 install --no-cache-dir faiss-cpu==${VERSION}

RUN python3 -c "import faiss; print(faiss.__version__)"

WORKDIR /workspace
CMD ["python3"]
