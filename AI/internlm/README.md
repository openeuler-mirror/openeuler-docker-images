# Quick reference

- The official InternLM Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# InternLM | openEuler

Current InternLM docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[InternLM](https://github.com/InternLM/InternLM) is the open-source large language model family of Shanghai AI Laboratory. The repository hosts the model code, model cards and the official guides for the InternLM series (InternLM3-8B-Instruct, etc.), including the ecosystem guide for running InternLM models on NPUs with Transformers.

This image ships the InternLM source tree with the [torch_npu](https://atomgit.com/ascend/pytorch) enabled Transformers inference stack, so InternLM models run seamlessly on the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/internlm/docs/Quick-start-Ascend.md). The image tracks the upstream `main` branch because existing releases predate the InternLM3 NPU guide.

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the InternLM documentation at [internlm.readthedocs.io](https://internlm.readthedocs.io/).

# Supported tags and respective Dockerfile links

The tag of each InternLM docker image consists of the InternLM source revision and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[main-68fdc71-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/internlm/main-68fdc71-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| InternLM main branch commit 68fdc71 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the internlm image
export IMAGE=openeuler/internlm:main-68fdc71-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-internlm \
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

Download `Shanghai_AI_Laboratory/internlm3-8b-instruct` from ModelScope (no token required, about 16 GB):

```bash
mkdir -p /root/internlm-quick-start
ln -sfn "$(python3 -c 'from modelscope import snapshot_download; print(snapshot_download("Shanghai_AI_Laboratory/internlm3-8b-instruct"))' | grep '^/' | tail -n 1)" /root/internlm-quick-start/model
ls /root/internlm-quick-start/model/config.json
```

Generate text with the official NPU recipe (FP16, chat template, `.npu()`), following the upstream `ecosystem/README_npu.md`:

```python
import torch
import torch_npu
from transformers import AutoModelForCausalLM, AutoTokenizer

model_dir = "/root/internlm-quick-start/model"
tokenizer = AutoTokenizer.from_pretrained(model_dir, trust_remote_code=True)
model = AutoModelForCausalLM.from_pretrained(
    model_dir,
    trust_remote_code=True,
    torch_dtype=torch.float16,
).npu()
model.eval()

messages = [
    {
        "role": "system",
        "content": "You are InternLM, a helpful, honest, and harmless AI assistant.",
    },
    {"role": "user", "content": "Please name one scenic spot in Shanghai."},
]
tokenized_chat = tokenizer.apply_chat_template(
    messages,
    tokenize=True,
    add_generation_prompt=True,
    return_tensors="pt",
).npu()

with torch.inference_mode():
    generated_ids = model.generate(
        tokenized_chat,
        max_new_tokens=64,
        do_sample=False,
    )
torch.npu.synchronize()

new_tokens = generated_ids[:, tokenized_chat.shape[-1]:]
response = tokenizer.batch_decode(new_tokens, skip_special_tokens=True)[0].strip()
print("model device:", next(model.parameters()).device)
print("response:", response)
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
