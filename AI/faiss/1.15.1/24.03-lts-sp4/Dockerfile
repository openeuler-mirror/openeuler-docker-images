ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=1.15.1

RUN dnf install -y python3-pip && \
    pip install --no-cache-dir faiss-cpu==${VERSION} && \
    dnf clean all

WORKDIR /workspace

CMD ["python3"]
