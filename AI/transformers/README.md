# Quick reference

- The official Transformers Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# Transformers | openEuler

Current Transformers docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[Transformers](https://github.com/huggingface/transformers) is a state-of-the-art machine learning framework for natural language processing, computer vision, audio and multimodal tasks. It provides thousands of pretrained models (`AutoModelForCausalLM`, `pipeline`, Trainer API, etc.) on top of PyTorch.

This image ships Transformers with [torch_npu](https://atomgit.com/ascend/pytorch) so that models run seamlessly on the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/transformers/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the Transformers documentation at [huggingface.co/docs/transformers](https://huggingface.co/docs/transformers).

# Supported tags and respective Dockerfile links

The tag of each Transformers docker image consists of the Transformers version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[5.22.1-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/transformers/5.22.1-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| Transformers 5.22.1 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the transformers image
export IMAGE=openeuler/transformers:5.22.1-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name transformers \
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

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
```

Generate text with `AutoModelForCausalLM` (uses the public `Qwen/Qwen2.5-1.5B-Instruct` model, no Hugging Face token required):

```python
import torch
import torch_npu
from transformers import AutoModelForCausalLM, AutoTokenizer

model_id = "Qwen/Qwen2.5-1.5B-Instruct"
device = "npu:0" if torch.npu.is_available() else "cpu"

tokenizer = AutoTokenizer.from_pretrained(model_id)
model = AutoModelForCausalLM.from_pretrained(model_id).to(device)

prompt = "Hello, my name is"
inputs = tokenizer(prompt, return_tensors="pt").to(device)
outputs = model.generate(**inputs, max_new_tokens=32)
print(tokenizer.decode(outputs[0], skip_special_tokens=True))
```

For faster model download in China, use the ModelScope or hf-mirror channel:

```bash
export HF_ENDPOINT=https://hf-mirror.com
# or
pip install modelscope
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
