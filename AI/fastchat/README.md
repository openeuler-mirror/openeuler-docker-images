# Quick reference

- The official FastChat Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# FastChat | openEuler

Current FastChat docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[FastChat](https://github.com/lm-sys/FastChat) is an open-source platform for training, serving and evaluating large language model based chatbots, best known for powering the Chatbot Arena. It provides a CLI, a Web UI and an OpenAI-compatible API server built on a controller / model worker architecture.

This image ships FastChat (`fschat`) with [torch_npu](https://atomgit.com/ascend/pytorch) so that model workers load and serve models seamlessly on the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/fastchat/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the FastChat documentation at [github.com/lm-sys/FastChat](https://github.com/lm-sys/FastChat).

# Supported tags and respective Dockerfile links

The tag of each FastChat docker image consists of the FastChat version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.2.36-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/fastchat/0.2.36-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| FastChat 0.2.36 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the fastchat image
export IMAGE=openeuler/fastchat:0.2.36-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-fastchat \
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

## Quick start 3: serve a model with the OpenAI-compatible API

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available())"
python3 -c "import fastchat; print('FastChat version:', fastchat.__version__)"
```

FastChat uses a controller to register and schedule model workers, and an API server to expose the OpenAI-compatible interface. Start the three foreground services in separate shells (uses the public `Qwen/Qwen2.5-0.5B-Instruct` model, no Hugging Face token required):

```bash
# 1. controller
python3 -m fastchat.serve.controller

# 2. model worker on the NPU (downloads the model from ModelScope)
FASTCHAT_USE_MODELSCOPE=True python3 -m fastchat.serve.model_worker \
  --model-path Qwen/Qwen2.5-0.5B-Instruct \
  --model-names Qwen2.5-0.5B-Instruct \
  --revision master \
  --device npu

# 3. OpenAI-compatible API server at http://127.0.0.1:8000/v1
python3 -m fastchat.serve.openai_api_server \
  --host 127.0.0.1 \
  --port 8000
```

Once the model worker has registered, send a chat completion request:

```bash
curl -fsS http://127.0.0.1:8000/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{"model":"Qwen2.5-0.5B-Instruct","messages":[{"role":"user","content":"Introduce yourself in one sentence."}],"max_tokens":64,"temperature":0}'
```

For faster model download in China, use the ModelScope or hf-mirror channel:

```bash
export HF_ENDPOINT=https://hf-mirror.com
# or
pip install modelscope
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
