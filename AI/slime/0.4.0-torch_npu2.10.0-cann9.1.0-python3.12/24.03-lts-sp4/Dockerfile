FROM quay.io/ascend/torch-npu:2.10.0.post6-cann9.1.0-910b-openeuler24.03-py3.12

# Use PyPI directly; the base image pip.conf points at a mirror that is
# unreachable from the CI builders.
ENV PIP_INDEX_URL=https://pypi.org/simple

ARG VERSION=0.4.0
ARG SLIME_ASCEND_REF=c69676fa94382175502101d9441c9aa82fd34a45

LABEL author="openEuler CloudNative SIG" description="slime RL training framework (Ascend-adapted) with Ascend NPU support (torch_npu + CANN)"


RUN dnf -y install --nodocs --setopt=install_weak_deps=False git && dnf clean all

# Install slime from the Ascend fork (upstream THUDM/slime has no Ascend support)
RUN git clone https://gitcode.com/Ascend/slime-ascend.git /opt/slime-ascend && \
    git -C /opt/slime-ascend checkout ${SLIME_ASCEND_REF} && \
    rm -rf /opt/slime-ascend/.git

# Install slime with the NumPy/PyArrow/pandas/OpenAI pins used by the Ascend CI
RUN printf 'numpy==1.26.4\npyarrow==20.0.0\npandas==2.2.3\nopenai==2.6.1\n' > /opt/slime-npu-constraints.txt && \
    PIP_CONSTRAINT=/opt/slime-npu-constraints.txt python3 -m pip install --no-cache-dir -e /opt/slime-ascend && \
    python3 -m pip install --no-cache-dir 'modelscope==1.37.0' && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
