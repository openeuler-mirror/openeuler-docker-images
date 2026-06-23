ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=3b0ff804f29ee5bb224854bf0e12fc0cbecb6db9

RUN dnf install -y \
      git gcc gcc-c++ make cmake \
      python3 python3-pip python3-devel \
      curl unzip which patch \
      java-11-openjdk-devel \
      libstdc++-devel \
      openssl-devel zlib-devel && \
    dnf clean all

RUN curl -fSL -o /usr/local/bin/bazelisk https://github.com/bazelbuild/bazelisk/releases/download/v1.22.0/bazelisk-linux-${TARGETARCH} && \
    chmod +x /usr/local/bin/bazelisk && \
    ln -s /usr/local/bin/bazelisk /usr/local/bin/bazel

WORKDIR /xla
RUN git init . && \
    git remote add origin https://github.com/openxla/xla.git && \
    git fetch --depth 1 origin ${VERSION} && \
    git checkout FETCH_HEAD

RUN python3 ./configure.py --backend=CPU

CMD ["/bin/bash"]
