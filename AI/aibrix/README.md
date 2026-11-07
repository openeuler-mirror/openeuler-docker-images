# Quick reference

- The official AIBrix Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# AIBrix | openEuler

Current AIBrix docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[AIBrix](https://github.com/vllm-project/aibrix) is an open-source cloud-native inference infrastructure platform built around vLLM. It provides a high-performance inference gateway, routing, token billing, observability and elastic autoscaling on Kubernetes, and also offers a local mode that runs the same gateway stack on a single machine without Kubernetes.

AIBrix is a Kubernetes platform project whose quick start routes requests from an Envoy-fronted Go gateway to a Python inference backend. This image packages that Python/inference component for Ascend NPUs: vLLM with [vLLM-Ascend](https://github.com/vllm-project/vllm-ascend) (`vllm==0.23.0`, `vllm-ascend==0.23.0`) on top of [torch_npu](https://atomgit.com/ascend/pytorch), together with the AIBrix release source tree at `/opt/aibrix` for the local mode deployment scripts. The Go gateway and Envoy are installed separately following the upstream quick start. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.10.0`, `torch_npu==2.10.0.post4`, `vllm==0.23.0` and `vllm-ascend==0.23.0` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/aibrix/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the AIBrix documentation at [aibrix.readthedocs.io](https://aibrix.readthedocs.io/).

# Supported tags and respective Dockerfile links

The tag of each AIBrix docker image consists of the AIBrix version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.8.0-torch_npu2.10.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/aibrix/0.8.0-torch_npu2.10.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| AIBrix 0.8.0 local mode backend (vLLM 0.23.0, vLLM-Ascend 0.23.0, torch_npu 2.10.0.post4, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the aibrix image
export IMAGE=openeuler/aibrix:0.8.0-torch_npu2.10.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-aibrix \
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

## Quick start 3: run the vLLM-Ascend backend for AIBrix local mode

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available())"
python3 -c "import importlib.metadata as m; print('vllm', m.version('vllm')); print('vllm-ascend', m.version('vllm-ascend'))"
```

Start the OpenAI-compatible inference backend that AIBrix local mode routes to (uses the public `Qwen/Qwen2.5-0.5B-Instruct` model, downloaded from ModelScope, no Hugging Face token required):

```bash
export VLLM_USE_MODELSCOPE=True
vllm serve Qwen/Qwen2.5-0.5B-Instruct \
  --served-model-name Qwen/Qwen2.5-0.5B-Instruct \
  --host 127.0.0.1 \
  --port 8000 \
  --max-model-len 2048 \
  --max-num-seqs 4 \
  --gpu-memory-utilization 0.2
```

Once the server is up, the vLLM log must show `backend=hccl`, which confirms the Ascend communication backend is active. Send a chat completion request:

```bash
curl -fsS http://127.0.0.1:8000/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{"model":"Qwen/Qwen2.5-0.5B-Instruct","messages":[{"role":"user","content":"Say hi in one sentence."}],"max_tokens":32,"temperature":0}'
```

To run the full AIBrix local mode on top of this backend, build the Go gateway from the source tree bundled at `/opt/aibrix` and install Envoy, then start `deployment/local/run-local.sh` with an `endpoints.yaml` pointing at the backend, following the [AIBrix local mode quick start](https://github.com/vllm-project/aibrix/blob/main/deployment/local/README.md). The gateway then serves the same API on port `10080`.

For faster model download in China, use the ModelScope or hf-mirror channel:

```bash
export HF_ENDPOINT=https://hf-mirror.com
# or
pip install modelscope
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
