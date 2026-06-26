ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG VERSION=6b54e46

RUN dnf install -y \
      git gcc gcc-c++ make cmake ninja-build patch \
      libstdc++-static glibc-static \
      curl \
      python3-pip && \
    dnf clean all

RUN pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple conan

WORKDIR /workspace
RUN git clone https://github.com/bytedance/bolt.git && \
    cd bolt && \
    git checkout ${VERSION}

WORKDIR /workspace/bolt
RUN bash scripts/install-bolt-deps.sh && \
    conan profile detect && \
    make release && \
    make export_release
