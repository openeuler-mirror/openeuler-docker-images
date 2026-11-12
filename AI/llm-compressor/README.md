# Quick reference

- The official LLM Compressor Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# LLM Compressor | openEuler

Current LLM Compressor docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[LLM Compressor](https://github.com/vllm-project/llm-compressor) is a vLLM-project toolkit for compressing large language models. With a few lines of code it applies one-shot quantization (RTN, GPTQ, AWQ, AutoRound, FP8/INT8), sparsification and other recipes, producing `compressed-tensors` models that vLLM can serve with lower latency and a smaller memory footprint.

This image ships LLM Compressor with [torch_npu](https://atomgit.com/ascend/pytorch) so that models are quantized and served seamlessly on the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.10.0` and `torch_npu==2.10.0.post6` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/llm-compressor/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the LLM Compressor documentation at [docs.vllm.ai/projects/llm-compressor](https://docs.vllm.ai/projects/llm-compressor/en/latest/).

# Supported tags and respective Dockerfile links

The tag of each LLM Compressor docker image consists of the LLM Compressor version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|
|[0.15.0-torch_npu2.10.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/llm-compressor/0.15.0-torch_npu2.10.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| LLM Compressor 0.15.0 (torch_npu 2.10.0.post6, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the llm-compressor image
export IMAGE=openeuler/llm-compressor:0.15.0-torch_npu2.10.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-llm-compressor \
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

## Quick start 3: quantize a model with oneshot on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
```

Apply a W4A16 RTN quantization to the tiny public model `nm-testing/tinysmokeqwen3` (about 10 MB, no Hugging Face token required), then reload the compressed model and run a forward pass:

```python
from pathlib import Path

import torch
import torch_npu
from compressed_tensors.quantization import QuantizationArgs, QuantizationScheme
from transformers import AutoModelForCausalLM, AutoTokenizer

from llmcompressor import oneshot
from llmcompressor.modifiers.quantization import QuantizationModifier

model_id = "nm-testing/tinysmokeqwen3"
device = "npu:0"
compressed_dir = Path.home() / "llm-compressor-work" / "compressed"

model = AutoModelForCausalLM.from_pretrained(model_id, dtype=torch.float16).to(device)
tokenizer = AutoTokenizer.from_pretrained(model_id)
recipe = QuantizationModifier(
    ignore=["lm_head"],
    config_groups={
        "group_0": QuantizationScheme(
            targets=["Linear"],
            weights=QuantizationArgs(num_bits=4, strategy="group", group_size=32),
        )
    },
)
torch.accelerator.max_memory_allocated = lambda device=None: 0
torch.accelerator.get_memory_info = lambda device=None: (0, 1)
oneshot(model=model, recipe=recipe, output_dir=str(compressed_dir))

reloaded = AutoModelForCausalLM.from_pretrained(compressed_dir, dtype=torch.float16).to(device)
inputs = tokenizer("hello", return_tensors="pt").to(device)
logits = reloaded(**inputs).logits
print("logits.dtype", logits.dtype)
print("logits.device", logits.device)
```

For faster model download in China, use the ModelScope or hf-mirror channel:

```bash
export HF_ENDPOINT=https://hf-mirror.com
# or
pip install modelscope
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
