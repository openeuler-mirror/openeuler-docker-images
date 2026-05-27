# 多阶段构建：编译阶段 + 运行时阶段
ARG BASE=openeuler/openeuler:24.03-lts-sp3

# ---- 编译阶段 ----
FROM ${BASE} AS build

ARG TARGETARCH
ARG VERSION=0.5.12
ARG SGL_REPO="https://github.com/sgl-project/sglang"

ENV LANG=C.UTF-8 \
    SGL_HOME=/opt/sglang \
    PATH=/root/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# 安装编译依赖和 Python 环境
RUN dnf -y update && \
    dnf -y install --nodocs --setopt=install_weak_deps=False \
        git \
        wget \
        curl \
        tar \
        gzip \
        make \
        cmake \
        gcc \
        gcc-c++ \
        python3 \
        python3-pip \
        python3-devel \
        openssl \
        openssl-devel \
        zlib \
        zlib-devel \
        bzip2 \
        xz \
        numactl \
        numactl-devel \
        rust cargo \
    && dnf clean all && rm -rf /var/cache/dnf

WORKDIR /opt

# 克隆 SGLang
RUN git clone --depth 1 --branch v${VERSION} ${SGL_REPO} ${SGL_HOME}

WORKDIR ${SGL_HOME}

# 安装 SGLang 及其依赖（CPU 版本）
RUN pip3 install --no-cache-dir --break-system-packages \
        --upgrade pip setuptools wheel && \
    pip3 install --no-cache-dir --break-system-packages \
        sglang

# 收集原生库产物
RUN mkdir -p ${SGL_HOME}/dist/lib && \
    find ${SGL_HOME} -type f $ -name "*.so" -o -name "*.a" $ \
        -exec cp -u {} ${SGL_HOME}/dist/lib/ \; 2>/dev/null || true

# ---- 运行时阶段 ----
FROM ${BASE} AS runtime

ARG VERSION=0.5.12

ENV LANG=C.UTF-8 \
    SGL_HOME=/opt/sglang \
    PATH=/opt/sglang/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# 安装运行时依赖（精简版）
RUN dnf -y install --nodocs --setopt=install_weak_deps=False \
        python3 \
        python3-pip \
        numactl \
        openssl \
        zlib \
        git \
        curl \
    && dnf clean all && rm -rf /var/cache/dnf

# 从编译阶段拷贝 SGLang
COPY --from=build ${SGL_HOME} ${SGL_HOME}

WORKDIR ${SGL_HOME}

# 设置元数据
LABEL org.opencontainers.image.title="sglang" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.description="SGLang LLM Inference Server on openEuler"

# 默认启动命令
CMD ["python3", "-m", "sglang.launch_server", "--help"]