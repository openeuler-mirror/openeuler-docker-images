# Quick reference

- The official PEFT Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# PEFT | openEuler

Current PEFT docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[PEFT](https://github.com/huggingface/peft) is a Hugging Face library for parameter-efficient fine-tuning of large models. Methods such as LoRA, AdaLoRA, IA³ and VeRA inject a tiny number of trainable parameters into a frozen base model — for a 3B model LoRA trains as little as ~0.1% of the weights — and adapters can be saved, shared and re-attached to the same base model with `PeftModel.from_pretrained`.

This image ships PEFT with [torch_npu](https://atomgit.com/ascend/pytorch) so that models run seamlessly on the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/peft/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the PEFT documentation at [huggingface.co/docs/peft](https://huggingface.co/docs/peft).

# Supported tags and respective Dockerfile links

The tag of each PEFT docker image consists of the PEFT version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.21.2-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/peft/0.21.2-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| PEFT 0.21.2 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the peft image
export IMAGE=openeuler/peft:0.21.2-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-peft \
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

## Quick start 3: LoRA with PEFT on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
python3 -c "import peft; print('peft', peft.__version__)"
```

Wrap a base model with a LoRA adapter: load the model onto the NPU, describe the injected LoRA matrices with `LoraConfig`, and call `get_peft_model` — the base weights stay frozen and only the LoRA matrices are trainable:

```python
import torch
import torch_npu
from transformers import AutoModelForCausalLM, AutoTokenizer
from peft import LoraConfig, TaskType, get_peft_model, PeftModel

model_id = "Qwen/Qwen2.5-1.5B-Instruct"
device = "npu:0"

model = AutoModelForCausalLM.from_pretrained(model_id, dtype=torch.bfloat16).to(device)

peft_config = LoraConfig(
    r=16,
    lora_alpha=32,
    task_type=TaskType.CAUSAL_LM,
)
peft_model = get_peft_model(model, peft_config)
peft_model.print_trainable_parameters()
peft_model.save_pretrained("output/peft-adapter")
```

Reload the saved adapter onto the same base model and run a generation to verify the chain end to end:

```python
tokenizer = AutoTokenizer.from_pretrained(model_id)
base = AutoModelForCausalLM.from_pretrained(model_id, dtype=torch.bfloat16).to(device)
peft_model = PeftModel.from_pretrained(base, "output/peft-adapter")

inputs = tokenizer("Preheat the oven to 350 degrees and place the cookie dough", return_tensors="pt").to(device)
outputs = peft_model.generate(**inputs, max_new_tokens=20, do_sample=False)
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
