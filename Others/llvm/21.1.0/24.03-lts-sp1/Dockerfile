ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=21.1.0

RUN dnf update -y \
    && dnf install -y wget xz glibc-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /usr/local

RUN if [ "$TARGETARCH" = "amd64" ]; then \
        BUILDARCH="X64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BUILDARCH="ARM64"; \
    fi \
    && wget https://github.com/llvm/llvm-project/releases/download/llvmorg-${VERSION}/LLVM-${VERSION}-Linux-${BUILDARCH}.tar.xz \
    && mkdir -p /usr/local/llvm \
    && tar -xvf LLVM-${VERSION}-Linux-${BUILDARCH}.tar.xz -C /usr/local/llvm --strip-components=1 \
    && rm -f LLVM-${VERSION}-Linux-${BUILDARCH}.tar.xz

WORKDIR /usr/local/llvm/bin

CMD ["./clang", "--version"]