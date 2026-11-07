FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

# Use PyPI directly; the base image pip.conf points at a mirror that is
# unreachable from the CI builders.
ENV PIP_INDEX_URL=https://pypi.org/simple

ARG VERSION=0.4.13

LABEL author="openEuler CloudNative SIG" description="LM Evaluation Harness (EleutherAI) with Ascend NPU support (torch_npu + CANN)"


# Install lm-eval with the HuggingFace backend, pinned to transformers<5.0 as validated on Ascend
RUN python3 -m pip install --no-cache-dir "lm_eval[hf]==${VERSION}" "transformers<5.0" && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
