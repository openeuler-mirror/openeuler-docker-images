# Quick reference

- The official Ollama Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# Ollama | openEuler

Current Ollama docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[Ollama](https://github.com/ollama/ollama) makes it simple to get large language models up and running locally: it packages model weights, configuration and prompts into an easy-to-use CLI and a local REST API.

This image builds Ollama from source with an experimental CANN backend (based on the llama.cpp GGML CANN backend), so models imported as Q4_0 GGUF run on the Ascend NPU. Ascend support is **not** part of the official Ollama releases yet; the image follows the [Ascend quick start guide](https://github.com/cosdt-ci-test/workflows/blob/main/projects/ollama/docs/Quick-start-Ascend.md), which applies the CANN integration patch to the latest release. The stack targets Ascend 910B4 devices with CANN 9.1.0.

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the Ollama documentation at [docs.ollama.com](https://docs.ollama.com/).

# Supported tags and respective Dockerfile links

The tag of each Ollama docker image consists of the Ollama version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.40.15-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/ollama/0.40.15-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| Ollama 0.40.15 (experimental CANN backend, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the ollama image
export IMAGE=openeuler/ollama:0.40.15-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-ollama \
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

## Quick start 3: run a model on Ascend NPU

The container runs `ollama serve` as its default command. Start it in the background and then use the CLI from `docker exec` (or run a bash shell as above and start `ollama serve` in the foreground in a second terminal):

```bash
docker run -d --name my-ollama \
    --device /dev/davinci0 \
    --device /dev/davinci_manager \
    --device /dev/devmm_svm \
    --device /dev/hisi_hdc \
    -v /usr/local/dcmi:/usr/local/dcmi \
    -v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \
    -v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/ \
    -v /usr/local/Ascend/driver/version.info:/usr/local/Ascend/driver/version.info \
    -v /etc/ascend_install.info:/etc/ascend_install.info \
    openeuler/ollama:0.40.15-cann9.1.0-python3.12-oe2403sp4

# confirm the service is up
curl -fsS http://127.0.0.1:11434/api/version
```

Import a GGUF model and chat with it. The CANN backend supports the Q4_0 quantization format (download the weights from ModelScope, no token required):

```bash
docker exec -it my-ollama bash
curl -L -o qwen2.5-0.5b-instruct-q4_0.gguf \
  https://modelscope.cn/models/Qwen/Qwen2.5-0.5B-Instruct-GGUF/resolve/master/qwen2.5-0.5b-instruct-q4_0.gguf

printf 'FROM ./qwen2.5-0.5b-instruct-q4_0.gguf\nPARAMETER num_ctx 1024\nPARAMETER num_gpu 999\nPARAMETER num_predict 64\n' > Modelfile
ollama create qwen2.5-ascend -f Modelfile

ASCEND_RT_VISIBLE_DEVICES=0 ollama run qwen2.5-ascend "Introduce yourself in one sentence." --verbose
```

The generation succeeds when the model replies and the server log reports a positive CANN buffer size and a full layer offload. A CPU fallback must not be treated as success.

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
