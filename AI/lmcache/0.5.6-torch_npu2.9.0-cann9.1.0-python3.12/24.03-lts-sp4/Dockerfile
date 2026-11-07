FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

# Use PyPI directly; the base image pip.conf points at a mirror that is
# unreachable from the CI builders.
ENV PIP_INDEX_URL=https://pypi.org/simple

ARG VERSION=0.5.6

LABEL author="openEuler CloudNative SIG" description="LMCache with Ascend NPU support (torch_npu + CANN)"


# Build and install LMCache from source with the Ascend build profile (skips CUDA-only deps)
RUN python3 -m pip install --no-cache-dir ninja packaging wheel "setuptools>=77.0.3,<81.0.0" "setuptools_scm>=8" grpcio==1.78.0 grpcio-tools==1.78.0 && \
    python3 -m pip download --no-deps --no-build-isolation --no-binary :all: lmcache==${VERSION} -d /tmp/lmcache-src && \
    BUILD_WITH_ASCEND=1 NO_GPU_EXT=1 ENABLE_CXX11_ABI=1 \
    ASCEND_HOME_PATH=/usr/local/Ascend/ascend-toolkit/latest \
    SETUPTOOLS_SCM_PRETEND_VERSION=${VERSION} \
    python3 -m pip install --no-cache-dir --no-build-isolation /tmp/lmcache-src/lmcache-${VERSION}.tar.gz && \
    rm -rf /tmp/lmcache-src && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
