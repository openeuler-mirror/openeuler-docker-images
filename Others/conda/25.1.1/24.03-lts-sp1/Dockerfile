ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=25.1.1-1

RUN yum update -y && \
    yum install -y wget&& \
    yum clean all && \
    rm -rf /var/cache/yum

RUN mkdir -p /var/log/conda && \
    chmod 777 /var/log/conda

RUN if [ "$TARGETARCH" = "amd64" ]; then \
        BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BUILDARCH="aarch64"; \
    fi; \
    wget https://repo.anaconda.com/miniconda/Miniconda3-py311_${VERSION}-Linux-${BUILDARCH}.sh -O ~/miniconda.sh && \
    bash ~/miniconda.sh -b -p /usr/local/miniconda && \
    rm -f ~/miniconda.sh
