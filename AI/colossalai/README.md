# Quick reference

- The official ColossalAI Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# ColossalAI | openEuler

Current ColossalAI docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[ColossalAI](https://github.com/hpcaitech/ColossalAI) is a large-scale parallel training framework that makes large model training faster, cheaper and scalable. It provides the Booster API with mixed parallelism plugins (TorchDDP, Gemini, tensor/pipeline parallelism, etc.) and a shardformer-based model sharding toolkit on top of PyTorch.

This image ships ColossalAI with [torch_npu](https://atomgit.com/ascend/pytorch) so that training workloads run seamlessly on the Ascend NPU (`colossalai.accelerator` selects the `npu` device with the HCCL communication backend). The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/colossalai/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the ColossalAI documentation at [colossalai.org](https://www.colossalai.org/).

# Supported tags and respective Dockerfile links

The tag of each ColossalAI docker image consists of the ColossalAI version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.5.0-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/colossalai/0.5.0-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| ColossalAI 0.5.0 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the colossalai image
export IMAGE=openeuler/colossalai:0.5.0-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name colossalai \
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

## Quick start 3: one training step on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
python3 -c "import torch, torch_npu, colossalai; from colossalai.accelerator import get_accelerator; acc = get_accelerator(); print('colossalai', colossalai.__version__); print('accel_name', acc.name); print('accel_device', acc.get_current_device())"
```

`accel_name npu` and `accel_device npu:0` mean ColossalAI has picked up the Ascend accelerator. Then wrap `Qwen/Qwen2.5-0.5B` (downloaded from the ModelScope mirror, about 1 GB on first use) with `launch` + `Booster(plugin=TorchDDPPlugin())` and perform one forward/backward/optimizer step. Save the following script as `train_step.py`:

```python
import torch
from torch.optim import AdamW
from modelscope import snapshot_download
from transformers import AutoModelForCausalLM, AutoTokenizer
import colossalai
from colossalai.accelerator import get_accelerator
from colossalai.booster import Booster
from colossalai.booster.plugin import TorchDDPPlugin

model_path = snapshot_download("Qwen/Qwen2.5-0.5B")
colossalai.launch(rank=0, world_size=1, host="127.0.0.1", port=29599)
acc = get_accelerator()
tokenizer = AutoTokenizer.from_pretrained(model_path)
if tokenizer.pad_token is None:
    tokenizer.pad_token = tokenizer.eos_token
model = AutoModelForCausalLM.from_pretrained(
    model_path, torch_dtype=torch.bfloat16,
)
optimizer = AdamW(model.parameters(), lr=1e-5)
booster = Booster(plugin=TorchDDPPlugin())
model, optimizer, _, _, _ = booster.boost(model, optimizer)
print("accel_name", acc.name)
print("accel_device", acc.get_current_device())
print("boosted_param_device", next(model.parameters()).device)
enc = tokenizer("ColossalAI on Ascend NPU", return_tensors="pt")
enc = {k: v.to(acc.get_current_device()) for k, v in enc.items()}
loss = model(**enc, labels=enc["input_ids"]).loss
booster.backward(loss, optimizer)
optimizer.step()
optimizer.zero_grad()
print("train_ok", True)
```

Run the script:

```bash
python3 train_step.py
```

`boosted_param_device npu:0` proves the Booster has placed the model parameters on the NPU. Warnings about `tensornvme` or `apex` are hints for the NVIDIA stack and can be ignored on Ascend.

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
