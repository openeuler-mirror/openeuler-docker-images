ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=2.1.9
ARG TARGETARCH
ARG BUILDARCH
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        BUILDARCH="x64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BUILDARCH="arm64"; \
    fi; \
    curl -fSL -o doris.tar.gz https://apache-doris-releases.oss-accelerate.aliyuncs.com/apache-doris-${VERSION}-bin-${BUILDARCH}.tar.gz && \
    mkdir -p /usr/local/bin && \
    tar -zxf doris.tar.gz -C /usr/local/ --strip-components=1
