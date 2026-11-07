# Quick reference

- The official Liger Kernel Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# Liger Kernel | openEuler

Current Liger Kernel docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[Liger Kernel](https://github.com/linkedin/Liger-Kernel) is a LinkedIn library of Triton kernels for LLM training: fused RMSNorm, SwiGLU, fused linear cross entropy and more. `AutoLigerKernelForCausalLM` or the `apply_liger_kernel_to_*` patch APIs replace operators in a model with fused implementations in one line, increasing training throughput and reducing memory usage — and since v0.8 it ships a native Ascend backend that lowers kernels through the Ascend Triton fork.

This image ships Liger Kernel with [torch_npu](https://atomgit.com/ascend/pytorch) and `triton-ascend` so that kernels run seamlessly on the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/liger-kernel/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the Liger Kernel documentation at [linkedin.github.io/Liger-Kernel](https://linkedin.github.io/Liger-Kernel/).

# Supported tags and respective Dockerfile links

The tag of each Liger Kernel docker image consists of the Liger Kernel version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.8.5-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/liger-kernel/0.8.5-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| Liger Kernel 0.8.5 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the liger-kernel image
export IMAGE=openeuler/liger-kernel:0.8.5-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-liger-kernel \
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

## Quick start 3: Liger kernels on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
python3 -c "import triton; import triton.backends.ascend; print('triton', triton.__version__)"
python3 -c "from importlib.metadata import version; print('liger-kernel', version('liger-kernel'))"
```

Combine Liger modules directly and run a few optimizer steps on the NPU — when the input tensors live on the NPU, these modules execute through Liger's Ascend backend:

```python
import torch
import torch_npu
from liger_kernel.transformers import LigerRMSNorm, LigerFusedLinearCrossEntropyLoss

hidden_size = 128
vocab_size = 256
norm = LigerRMSNorm(hidden_size).npu()
loss_fn = LigerFusedLinearCrossEntropyLoss()
x = torch.randn(4, 16, hidden_size, dtype=torch.bfloat16, device='npu', requires_grad=True)
target = torch.randint(vocab_size, (4, 16), device='npu')
weight = torch.randn(vocab_size, hidden_size, dtype=torch.bfloat16, device='npu', requires_grad=True)
optimizer = torch.optim.SGD([weight, *norm.parameters()], lr=0.01)

for _ in range(3):
    optimizer.zero_grad()
    x.grad = None
    hidden = norm(x)
    loss = loss_fn(weight, hidden.reshape(-1, hidden_size), target.reshape(-1))
    assert torch.isfinite(loss).item()
    loss.backward()
    optimizer.step()

print('device:', x.device.type)
print('loss:', f'{loss.item():.4f}')
```

To accelerate a full model, let `AutoLigerKernelForCausalLM` apply the optimized kernels automatically when loading a supported model:

```python
import torch
import torch_npu
from liger_kernel.transformers import AutoLigerKernelForCausalLM

model = AutoLigerKernelForCausalLM.from_pretrained(
    "Qwen/Qwen3-0.6B", dtype=torch.bfloat16,
).to('npu').train()
```

For faster model download in China, use the ModelScope or hf-mirror channel:

```bash
export HF_ENDPOINT=https://hf-mirror.com
# or
pip install modelscope
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
