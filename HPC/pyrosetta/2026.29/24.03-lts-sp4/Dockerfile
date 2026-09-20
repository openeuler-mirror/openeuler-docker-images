ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=v2026.29-dev62280

RUN dnf update -y \
    && dnf install -y \
        git gcc gcc-c++ make cmake ninja-build clang llvm \
        python3 python3-devel python3-pip python3-setuptools \
        xz zlib-devel wget which findutils \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN git clone --depth 1 --branch ${VERSION} \
        --recurse-submodules --shallow-submodules \
        https://github.com/RosettaCommons/rosetta.git /opt/rosetta

# binder 使用 LLVM 6.0.1(2018) 的 clang，无法自动定位 openEuler 的 GCC 12
# libstdc++ 头文件（报错 'cstddef'/'bits/c++config.h' file not found）。
# 需通过 --binder-llvm-options 显式注入 GCC 12 的 C++ 标准库头文件搜索路径。
# 多架构子目录名通过 `gcc -dumpmachine` 动态获取（x86_64/aarch64 均适用）。
RUN cd /opt/rosetta/source/src/python/PyRosetta \
    && multiarch="$(gcc -dumpmachine)" \
    && python3 build.py -j$(nproc) \
        --binder-llvm-options "-isystem /usr/include/c++/12 -isystem /usr/include/c++/12/${multiarch} -isystem /usr/include/c++/12/backward" \
        --create-package /opt/pyrosetta-package

RUN python3 -m pip install --no-cache-dir --target /opt/pyrosite numpy \
    && python3 -m pip install --no-cache-dir --target /opt/pyrosite /opt/pyrosetta-package/setup

FROM ${BASE}

RUN dnf update -y \
    && dnf install -y python3 zlib \
    && dnf clean all \
    && rm -rf /var/cache/dnf

COPY --from=builder /opt/pyrosite /opt/pyrosite

ENV PYTHONPATH=/opt/pyrosite

WORKDIR /workspace

CMD ["/bin/bash"]