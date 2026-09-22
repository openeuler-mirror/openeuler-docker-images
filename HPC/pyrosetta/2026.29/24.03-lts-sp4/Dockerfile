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