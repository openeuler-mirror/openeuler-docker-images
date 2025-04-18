ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=1.25.1

RUN curl -fSL -o istio.tar.gz https://github.com/istio/istio/releases/download/${VERSION}/istio-${VERSION}-linux-${TARGETARCH}.tar.gz && \
    mkdir -p /usr/local/istio/ && \
    tar -zxf istio.tar.gz -C /usr/local/istio/ --strip-components=1

ENV PATH=$PATH:/usr/local/istio/bin/

CMD ["istioctl", "version"]
