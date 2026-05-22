ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG JAX_VERSION=0.10.1

RUN dnf install -y python3-pip && dnf clean all

RUN pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple jax==${JAX_VERSION} jaxlib
