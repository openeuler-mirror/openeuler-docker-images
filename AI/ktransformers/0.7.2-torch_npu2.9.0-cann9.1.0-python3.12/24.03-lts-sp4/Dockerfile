FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

# Use PyPI directly; the base image pip.conf points at a mirror that is
# unreachable from the CI builders.
ENV PIP_INDEX_URL=https://pypi.org/simple

ARG VERSION=0.7.2

LABEL author="openEuler CloudNative SIG" description="KTransformers with Ascend NPU support (torch_npu + CANN)"


# System build dependencies required by the install step of the upstream Ascend tutorial
RUN yum install -y hwloc-devel numactl-devel pkgconfig patchelf && \
    yum clean all && \
    rm -rf /var/cache/yum

WORKDIR /opt/ktransformers

# Fetch the sources and keep them (the archived framework tree in archive/ is the
# one used by the upstream Ascend tutorials). Apply the aarch64 llamafile tweak
# from the tutorial.
RUN git clone --branch "v${VERSION}" --depth 1 https://github.com/kvcache-ai/ktransformers.git /opt/ktransformers && \
    sed -i 's|^#define iqk_mul_mat iqk_mul_mat_arm82|// &|; s|^#define iqk_mul_mat_moe iqk_mul_mat_moe_arm82|// &|' \
        /opt/ktransformers/archive/third_party/llamafile/iqk_mul_mat_arm82.cpp

# Python runtime dependencies from the upstream Ascend tutorial
# (torch and torch_npu come from the base image)
RUN python3 -m pip install --no-cache-dir transformers==4.57.1 && \
    python3 -m pip install --no-cache-dir -r /opt/ktransformers/archive/requirements-local_chat.txt && \
    python3 -m pip install --no-cache-dir -r /opt/ktransformers/archive/ktransformers/server/requirements.txt && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
