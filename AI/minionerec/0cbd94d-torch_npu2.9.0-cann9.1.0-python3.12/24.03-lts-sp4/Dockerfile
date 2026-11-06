FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=0cbd94d

LABEL author="openEuler CloudNative SIG" description="MiniOneRec (generative recommendation framework) with Ascend NPU support (torch_npu + CANN)"


# Clone MiniOneRec and install its NPU dependencies (torch/torch_npu already
# come from the base image and are not reinstalled). The pinned versions follow
# the Ascend quick start guard; bitsandbytes 0.48.1 is pinned to the release
# that ships aarch64 wheels (sft.py/evaluate.py import it unconditionally).
RUN dnf install -y git && dnf clean all && \
    git clone https://github.com/AkaliKong/MiniOneRec.git /opt/MiniOneRec && \
    git -C /opt/MiniOneRec checkout ${VERSION} && \
    python3 -m pip install --no-cache-dir \
        modelscope transformers==4.57.1 accelerate==1.10.1 datasets==4.2.0 \
        tokenizers==0.22.1 fire==0.7.1 pandas==2.2.2 tqdm bitsandbytes==0.48.1 \
        trl==0.24.0 scikit-learn==1.5.2 wandb==0.22.2 && \
    python3 -m pip cache purge

WORKDIR /opt/MiniOneRec

CMD ["/bin/bash"]
