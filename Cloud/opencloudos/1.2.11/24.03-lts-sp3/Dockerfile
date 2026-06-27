ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG VERSION=1.2.11

RUN dnf install -y curl bzip2 && \
    ARCH=$(uname -m) && \
    curl -fSL "https://github.com/OpenCloudOS/nettrace/releases/download/v${VERSION}/nettrace-${VERSION}-1.tl3.${ARCH}.tar.bz2" \
        -o nettrace.tar.bz2 && \
    tar -xjf nettrace.tar.bz2 && \
    mv nettrace-${VERSION}-1.tl3.${ARCH}/nettrace /usr/local/bin/nettrace && \
    rm -rf nettrace.tar.bz2 nettrace-${VERSION}-1.tl3.${ARCH} && \
    dnf clean all

CMD ["nettrace", "--help"]
