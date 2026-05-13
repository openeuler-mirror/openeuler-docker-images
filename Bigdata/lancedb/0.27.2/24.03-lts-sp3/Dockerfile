ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG LANCEDB_VERSION=0.27.2

RUN yum install -y python3 python3-pip && \
    yum clean all

RUN pip3 install --no-cache-dir lancedb==${LANCEDB_VERSION}
    
WORKDIR /workspace

CMD ["python3"]

