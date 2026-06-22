ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=3b0ff80

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
RUN git clone --branch ${VERSION} --depth 1 https://github.com/openxla/xla.git .

RUN python3 ./configure.py --backend=CPU

CMD ["/bin/bash"]
