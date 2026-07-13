ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=135c491

RUN dnf install -y \
      curl git gcc gcc-c++ make \
      python3 python3-pip python3-devel \
      java-11-openjdk-devel \
      which unzip && \
    dnf clean all

RUN pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple \
      numpy wheel packaging requests opt_einsum && \
    pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple \
      keras_preprocessing --no-deps

RUN curl -fSL -o /usr/local/bin/bazel \
      "https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-${TARGETARCH}" && \
    chmod +x /usr/local/bin/bazel

RUN git clone https://github.com/bytedance/monolith.git && \
    cd monolith && git checkout ${VERSION}

WORKDIR /workspace/monolith
