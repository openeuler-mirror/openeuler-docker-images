ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=28.2.1
ARG TARGETARCH
ARG BUILDARCH

RUN dnf update -y \
    && dnf install -y wget \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /usr/local

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      BUILDARCH="aarch64"; \
    fi \
    && wget https://download.docker.com/linux/static/stable/${BUILDARCH}/docker-${VERSION}.tgz \
    && tar -zxvf docker-${VERSION}.tgz \
    && rm -f docker-${VERSION}.tgz

WORKDIR /usr/local/docker

CMD ["./docker", "--help"]