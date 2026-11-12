# Quick reference

- The official llama.cpp Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# llama.cpp | openEuler

Current llama.cpp docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[llama.cpp](https://github.com/ggml-org/llama.cpp) is a lightweight C/C++ inference engine for GGUF large language models. It runs LLM inference with minimal setup and state-of-the-art performance on a broad range of hardware.

This image ships llama.cpp with the [GGML CANN backend](https://github.com/ggml-org/llama.cpp/blob/master/docs/backend/CANN.md) so that inference is offloaded to the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/llama.cpp/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the llama.cpp documentation at [github.com/ggml-org/llama.cpp/tree/master/docs](https://github.com/ggml-org/llama.cpp/tree/master/docs).

# Supported tags and respective Dockerfile links

The tag of each llama.cpp docker image consists of the llama.cpp version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/llama.cpp/0.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| llama.cpp 0.9.0 (CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the llama.cpp image
export IMAGE=openeuler/llama.cpp:0.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-llama.cpp \
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

## Quick start 3: inference on Ascend NPU

Download a GGUF model (Q4_0 is one of the quantization types supported by the CANN backend on 910B, together with FP16, BF16 and Q8_0):

```bash
curl -L -o qwen2.5-0.5b-instruct-q4_0.gguf \
  https://modelscope.cn/models/Qwen/Qwen2.5-0.5B-Instruct-GGUF/resolve/master/qwen2.5-0.5b-instruct-q4_0.gguf
head -c 4 qwen2.5-0.5b-instruct-q4_0.gguf
```

Run a one-shot completion with all layers offloaded to the NPU (`llama-completion`, `llama-cli`, `llama-server` and the other tools are installed in `/usr/local/bin`):

```bash
ASCEND_RT_VISIBLE_DEVICES=0 llama-completion \
    -m qwen2.5-0.5b-instruct-q4_0.gguf \
    -p "Building a website can be done in 10 simple steps:" \
    -n 64 -no-cnv -ngl 99 -sm none -mg 0 -v
```

The generation succeeds when the process exits with code 0 and the log contains a `load_tensors: ... CANN0 model buffer size = ...` line, which proves that the model weights were loaded onto the NPU. Without it the process may still return 0 after silently falling back to the CPU.

For faster model download in China, download GGUF files from ModelScope (as above) or use the hf-mirror channel:

```bash
export HF_ENDPOINT=https://hf-mirror.com
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
