FROM quay.io/ascend/torch-npu:2.10.0.post6-cann9.1.0-910b-openeuler24.03-py3.12

# Use PyPI directly; the base image pip.conf points at a mirror that is
# unreachable from the CI builders.
ENV PIP_INDEX_URL=https://pypi.org/simple

# Harden git against the flaky CI network (force HTTP/1.1, large post buffer).
ENV GIT_CONFIG_COUNT=2 \
    GIT_CONFIG_KEY_0=http.version \
    GIT_CONFIG_VALUE_0=HTTP/1.1 \
    GIT_CONFIG_KEY_1=http.postBuffer \
    GIT_CONFIG_VALUE_1=524288000

ARG VERSION=0.4.0
ARG SLIME_ASCEND_REF=c69676fa94382175502101d9441c9aa82fd34a45

LABEL author="openEuler CloudNative SIG" description="slime RL training framework (Ascend-adapted) with Ascend NPU support (torch_npu + CANN)"


RUN dnf -y install --nodocs --setopt=install_weak_deps=False git && dnf clean all

# Install slime from the Ascend fork (upstream THUDM/slime has no Ascend support)
# build.sh initializes the slime submodule at the pinned upstream commit and
# applies the npu-compat / upstream-fixes patch series; the installable package
# tree is the slime/ subdirectory afterwards.
RUN git clone --recurse-submodules https://gitcode.com/Ascend/slime-ascend.git /opt/slime-ascend && \
    git -C /opt/slime-ascend checkout ${SLIME_ASCEND_REF} && \
    bash /opt/slime-ascend/build.sh && \
    rm -rf /opt/slime-ascend/.git /opt/slime-ascend/slime/.git

# Install slime with the NumPy/PyArrow/pandas/OpenAI pins used by the Ascend CI
RUN printf 'numpy==1.26.4\npyarrow==20.0.0\npandas==2.2.3\nopenai==2.6.1\n' > /opt/slime-npu-constraints.txt && \
    PIP_CONSTRAINT=/opt/slime-npu-constraints.txt python3 -m pip install --no-cache-dir -e /opt/slime-ascend/slime && \
    python3 -m pip install --no-cache-dir 'modelscope==1.37.0' && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
