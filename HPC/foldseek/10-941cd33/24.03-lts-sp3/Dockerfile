ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=10-941cd33

RUN if [ "$TARGETARCH" = "amd64" ]; then \
        FOLDSEEK_ARCH="avx2"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        FOLDSEEK_ARCH="arm64"; \
    else \
        echo "Unsupported architecture: $TARGETARCH" && exit 1; \
    fi && \
    curl -fSL -o /tmp/foldseek.tar.gz \
        https://github.com/steineggerlab/foldseek/releases/download/${VERSION}/foldseek-linux-${FOLDSEEK_ARCH}.tar.gz && \
    mkdir -p /opt/foldseek && \
    tar -xzf /tmp/foldseek.tar.gz -C /opt/foldseek --strip-components=1 && \
    rm -f /tmp/foldseek.tar.gz

ENV PATH=/opt/foldseek/bin:$PATH
