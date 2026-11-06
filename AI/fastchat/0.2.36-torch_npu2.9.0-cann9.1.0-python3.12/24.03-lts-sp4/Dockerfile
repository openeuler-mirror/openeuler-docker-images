FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=0.2.36

LABEL author="openEuler CloudNative SIG" description="FastChat with Ascend NPU support (torch_npu + CANN)"


# Install FastChat (fschat) with the model worker extra and the serving deps pinned by the Ascend quick start guard
RUN python3 -m pip install --no-cache-dir "fschat[model_worker]==${VERSION}" \
        "transformers==4.57.6" \
        "modelscope==1.37.0" \
        "fastapi==0.141.1" \
        "uvicorn==0.52.0" && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
