ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

# RosettaCommons/rosetta publishes the 3.15 release as tag "v3.15"
# (commit df75a9c48e763e52a7aa3f5dfba077f4da88dbf5). The auto-generated
# "v3.15-dev*" tag used by the upgrade bot does not exist.
ARG VERSION=v3.15

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

# binder uses LLVM 6.0.1's clang and cannot locate openEuler GCC 12's
# libstdc++ headers automatically ("cstddef"/"bits/c++config.h" not found).
# Inject the GCC 12 C++ include paths explicitly; the multiarch subdirectory
# is resolved dynamically so the same Dockerfile works on x86_64 and aarch64.
RUN cd /opt/rosetta/source/src/python/PyRosetta \
    && multiarch="$(gcc -dumpmachine)" \
    && python3 build.py -j$(nproc) \
        --binder-llvm-options "-isystem /usr/include/c++/12 -isystem /usr/include/c++/12/${multiarch} -isystem /usr/include/c++/12/backward" \
        --create-package /opt/pyrosetta-package

# Pin the Python package metadata to 3.15 and skip ez_setup: the base image's
# setuptools no longer provides pkg_resources, so ez_setup would try to download
# setuptools 3.3, which does not work on Python 3.11.
RUN sed -i '/ez_setup/d' /opt/pyrosetta-package/setup/setup.py \
    && printf '{"version": "3.15"}\n' > /opt/pyrosetta-package/version.json

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
