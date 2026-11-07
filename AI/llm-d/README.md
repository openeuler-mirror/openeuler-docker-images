# Quick reference

- The official llm-d Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# llm-d | openEuler

Current llm-d docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[llm-d](https://github.com/llm-d/llm-d) is an open-source Kubernetes-native inference platform that disaggregates LLM serving into composable layers. An Envoy front proxy and the llm-d-router endpoint picker (EPP) provide prefix-aware routing and scheduling on top of standard inference engines such as vLLM.

llm-d is a Kubernetes platform project whose no-Kubernetes quick start composes three plain processes: vLLM as the model server, EPP (a Go binary from [llm-d-router](https://github.com/llm-d/llm-d-router)) and Envoy. This image packages the Python/model-server component for Ascend NPUs: vLLM with [vLLM-Ascend](https://github.com/vllm-project/vllm-ascend) (`vllm==0.23.0`, `vllm-ascend==0.23.0`) on top of [torch_npu](https://atomgit.com/ascend/pytorch), together with the llm-d release source tree at `/opt/llm-d` for the no-Kubernetes deployment guide configurations. EPP and Envoy are deployed separately following the upstream guide. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.10.0`, `torch_npu==2.10.0.post4`, `vllm==0.23.0` and `vllm-ascend==0.23.0` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/llm-d/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the llm-d documentation at [llm-d.ai](https://llm-d.ai/).

# Supported tags and respective Dockerfile links

The tag of each llm-d docker image consists of the llm-d version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[1.0.0-torch_npu2.10.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/llm-d/1.0.0-torch_npu2.10.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| llm-d 1.0.0 model server stack (vLLM 0.23.0, vLLM-Ascend 0.23.0, torch_npu 2.10.0.post4, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the llm-d image
export IMAGE=openeuler/llm-d:1.0.0-torch_npu2.10.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-llm-d \
--device $DEVICE \
--device /dev/davinci_manager \
--device /dev/devmm_svm \
--device /dev/hisi_hdc \
-v /usr/local/dcmi:/usr/local/dcmi \
-v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \
-v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/ \
-v /usr/local/Ascend/driver/version.info:/usr/local/Ascend/driver/version.info \
-v /etc/ascend_install.info:/etc/ascend_install.info \
-v /root/.cache:/root/.cache \
-it $IMAGE bash
```

## Quick start 3: run the vLLM-Ascend model server for the llm-d routing stack

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available())"
python3 -c "import importlib.metadata as m; print('vllm', m.version('vllm')); print('vllm-ascend', m.version('vllm-ascend'))"
```

Start the model server that the llm-d routing stack forwards to (uses the public `Qwen/Qwen3-0.6B` model, downloaded from ModelScope, no Hugging Face token required):

```bash
export VLLM_USE_MODELSCOPE=true
vllm serve Qwen/Qwen3-0.6B \
  --host 127.0.0.1 \
  --port 8000 \
  --served-model-name Qwen/Qwen3-0.6B \
  --max-model-len 2048 \
  --max-num-seqs 4 \
  --gpu-memory-utilization 0.3 \
  --trust-remote-code \
  --enforce-eager
```

Once the server is up, the vLLM log must show `backend=hccl`, which confirms the Ascend communication backend is active. Send a completion request:

```bash
curl -sS http://127.0.0.1:8000/v1/completions \
  -H 'Content-Type: application/json' \
  -d '{"model":"Qwen/Qwen3-0.6B","prompt":"Hello","max_tokens":8,"temperature":0}'
```

To run the full routing stack on top of this model server, build the EPP binary from [llm-d-router](https://github.com/llm-d/llm-d-router), install Envoy, and take the router configurations from `/opt/llm-d/guides/no-kubernetes-deployment`, following the [llm-d no-Kubernetes deployment guide](https://github.com/llm-d/llm-d/tree/main/guides/no-kubernetes-deployment). Requests sent to the Envoy port `8081` are then routed through EPP to the vLLM worker.

For faster model download in China, use the ModelScope or hf-mirror channel:

```bash
export HF_ENDPOINT=https://hf-mirror.com
# or
pip install modelscope
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
