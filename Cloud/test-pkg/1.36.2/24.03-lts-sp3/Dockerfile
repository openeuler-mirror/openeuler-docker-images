ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=1.36.2

RUN dnf update -y && \
    dnf install -y wget ca-certificates && \
    wget -O /usr/local/bin/kubectl "https://dl.k8s.io/release/v${VERSION}/bin/linux/${TARGETARCH}/kubectl" && \
    wget -O /tmp/kubectl.sha256 "https://dl.k8s.io/release/v${VERSION}/bin/linux/${TARGETARCH}/kubectl.sha256" && \
    echo "$(cat /tmp/kubectl.sha256)  /usr/local/bin/kubectl" | sha256sum -c - && \
    chmod +x /usr/local/bin/kubectl && \
    rm -f /tmp/kubectl.sha256 && \
    dnf remove -y wget && \
    dnf clean all && \
    rm -rf /var/cache/dnf

ENTRYPOINT ["kubectl"]
CMD ["--help"]
