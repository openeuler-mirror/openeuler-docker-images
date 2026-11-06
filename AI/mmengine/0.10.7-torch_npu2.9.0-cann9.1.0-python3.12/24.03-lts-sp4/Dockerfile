FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=0.10.7

LABEL author="openEuler CloudNative SIG" description="MMEngine (OpenMMLab) with Ascend NPU support (torch_npu + CANN)"


# Install mmengine and switch opencv to the headless variant for headless containers
RUN python3 -m pip install --no-cache-dir mmengine==${VERSION} && \
    python3 -m pip uninstall -y opencv-python && \
    python3 -m pip install --no-cache-dir opencv-python-headless && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
