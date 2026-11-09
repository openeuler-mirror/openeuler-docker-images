# Quick reference

- The official LlamaFactory Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# LlamaFactory | openEuler

Current LlamaFactory docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[LlamaFactory](https://github.com/hiyouga/LlamaFactory) is a unified fine-tuning framework for 100+ LLMs and VLMs. It provides built-in SFT, LoRA, freeze-tuning, long-context, DPO, PPO and KTO pipelines together with a WebUI (LLaMA Board), CLI tools and an OpenAI-style API server.

This image ships LlamaFactory with [torch_npu](https://atomgit.com/ascend/pytorch) so fine-tuning runs seamlessly on the Ascend NPU. The software stack follows the official LlamaFactory NPU requirements: `torch==2.10.0`, `torch_npu==2.10.0.post7`, `triton-ascend==3.2.1`, `deepspeed<=0.18.4` and the evaluation extras (nltk, jieba, rouge-chinese) with CANN 9.1.0 on Python 3.12, as documented in the [NPU installation guide](https://llamafactory.readthedocs.io/en/latest/multibackend/npu/npu_installation.html).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the LlamaFactory documentation at [llamafactory.readthedocs.io](https://llamafactory.readthedocs.io/).

# Supported tags and respective Dockerfile links

The tag of each LlamaFactory docker image consists of the LlamaFactory version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.9.5-torch_npu2.10.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/llamafactory/0.9.5-torch_npu2.10.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| LlamaFactory 0.9.5 (torch_npu 2.10.0.post7, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the LlamaFactory image
export IMAGE=openeuler/llamafactory:0.9.5-torch_npu2.10.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-llamafactory \
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

## Quick start 3: LoRA fine-tuning on Ascend NPU

Validate the environment inside the container:

```bash
source /usr/local/Ascend/ascend-toolkit/set_env.sh
python3 -c "import torch, torch_npu, llamafactory; print('torch_npu', torch_npu.__version__); print('is_available:', torch.npu.is_available())"
llamafactory-cli version
```

Then get the upstream example configs (the PyPI wheel does not ship the `examples/` directory) and run the built-in identity LoRA SFT example (edit `model_name_or_path` in the yaml to point to a model that fits your device, e.g. a Qwen model; weights are downloaded from Hugging Face or ModelScope at runtime):

```bash
git clone --depth 1 --branch v0.9.5 https://github.com/hiyouga/LlamaFactory.git
cd LlamaFactory
llamafactory-cli train examples/train_lora/llama3_lora_sft.yaml
```

Chat with the fine-tuned LoRA adapter and export the merged weights:

```bash
llamafactory-cli chat examples/inference/llama3_lora.yaml
llamafactory-cli export examples/merge_lora/llama3_lora.yaml
```

Start the LLaMA Board WebUI (port 7860) or the OpenAI-style API server (port 8000):

```bash
llamafactory-cli webui
llamafactory-cli api examples/inference/llama3_api.yaml
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
