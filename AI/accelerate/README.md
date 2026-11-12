# Quick reference

- The official Accelerate Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# Accelerate | openEuler

Current Accelerate docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[Accelerate](https://github.com/huggingface/accelerate) is a Hugging Face library for distributed training and mixed precision on any device. The same PyTorch training code runs unchanged across single-node and multi-node setups: `Accelerator` handles device placement and `accelerator.backward`, while `accelerate launch` starts DDP-style multi-card jobs and `init_empty_weights`/`load_checkpoint_and_dispatch` shard large models across devices.

This image ships Accelerate with [torch_npu](https://atomgit.com/ascend/pytorch) so that models run seamlessly on the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/accelerate/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the Accelerate documentation at [huggingface.co/docs/accelerate](https://huggingface.co/docs/accelerate).

# Supported tags and respective Dockerfile links

The tag of each Accelerate docker image consists of the Accelerate version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[1.15.0-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/accelerate/1.15.0-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| Accelerate 1.15.0 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the accelerate image
export IMAGE=openeuler/accelerate:1.15.0-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-accelerate \
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

## Quick start 3: training with Accelerate on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
python3 -c "import accelerate; print('accelerate', accelerate.__version__)"
```

`accelerate env` reports how Accelerate probes the platform; on a healthy NPU environment it prints `PyTorch accelerator: NPU`:

```bash
accelerate env
```

Run a minimal training loop on the NPU: `Accelerator()` auto-detects the NPU device, `accelerator.prepare` moves the model and dataloader onto the card, and `accelerator.backward` replaces `loss.backward()`:

```python
import torch
import torch_npu
from torch import nn
from torch.utils.data import DataLoader, TensorDataset
from accelerate import Accelerator

x = torch.linspace(-1.0, 1.0, 64).unsqueeze(1)
y = 2 * x + 1 + 0.05 * torch.randn_like(x)
ds = TensorDataset(x, y)
loader = DataLoader(ds, batch_size=8, shuffle=True)
model = nn.Linear(1, 1)
optim = torch.optim.SGD(model.parameters(), lr=0.1)

accelerator = Accelerator()
model, optim, loader = accelerator.prepare(model, optim, loader)
loss_fn = nn.MSELoss()
for step, (xb, yb) in enumerate(loader):
    preds = model(xb)
    loss = loss_fn(preds, yb)
    accelerator.backward(loss)
    optim.step()
    optim.zero_grad()
    if step == 2:
        break
print(f"device={accelerator.device.type} final_loss={loss.item():.4f}")
```

Save it as `train_npu.py` and it prints `device=npu final_loss=...`. On a multi-card machine, launch the same script on two NPUs with `accelerate launch`:

```bash
ASCEND_RT_VISIBLE_DEVICES=0,1 accelerate launch --num_processes 2 --mixed_precision bf16 train_npu.py
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
