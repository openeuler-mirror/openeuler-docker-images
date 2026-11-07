# Quick reference

- The official Flash Linear Attention Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# Flash Linear Attention | openEuler

Current Flash Linear Attention docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[Flash Linear Attention (FLA)](https://github.com/fla-org/flash-linear-attention) provides efficient Triton kernels for linear attention models — Gated DeltaNet, GLA, RetNet, and more — together with a zoo of linear-attention language models built on top of them.

This image ships FLA with [torch_npu](https://atomgit.com/ascend/pytorch) and the [Triton-Ascend](https://triton-ascend.readthedocs.io/) backend, so the linear attention layers run natively on the Ascend NPU (`fla.utils.IS_NPU` is `True` and `device_platform` is `npu`). The software stack is validated on a single Ascend 910B4 card with CANN 9.2.0, `torch==2.10.0` and `torch_npu==2.10.0.post7` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/flash-linear-attention/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the FLA documentation at [fla.readthedocs.io](https://fla.readthedocs.io/).

# Supported tags and respective Dockerfile links

The tag of each Flash Linear Attention docker image consists of the Flash Linear Attention version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|
|[0.6.0-torch_npu2.10.0-cann9.2.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/flash-linear-attention/0.6.0-torch_npu2.10.0-cann9.2.0-python3.12/24.03-lts-sp4/Dockerfile)| Flash Linear Attention 0.6.0 (torch_npu 2.10.0.post7, CANN 9.2.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the flash-linear-attention image
export IMAGE=openeuler/flash-linear-attention:0.6.0-torch_npu2.10.0-cann9.2.0-python3.12-oe2403sp4
docker run --rm \
--name my-flash-linear-attention \
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

## Quick start 3: GatedDeltaNet forward and backward on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
python3 -c "import fla; from fla.utils import IS_NPU, device_platform; print('fla', fla.__version__); print('IS_NPU', IS_NPU); print('device_platform', device_platform)"
```

Run a real `GatedDeltaNet` forward and backward pass on the NPU (linear layer, causal conv1d, gated delta rule and gated RMSNorm are all exercised):

```python
import torch
import torch_npu

from fla.layers import GatedDeltaNet
from fla.utils import IS_NPU, device_platform

assert IS_NPU
assert device_platform == "npu"
torch.manual_seed(42)

layer = GatedDeltaNet(
    hidden_size=512,
    head_dim=64,
    num_heads=6,
    expand_v=2,
    mode="chunk",
).to(device="npu", dtype=torch.bfloat16).train()

x = torch.randn(
    1,
    128,
    512,
    device="npu",
    dtype=torch.bfloat16,
    requires_grad=True,
)
y = layer(x)[0]
loss = y.float().square().mean()
loss.backward()
torch.npu.synchronize()

print("device", y.device.type)
print("output_shape", tuple(y.shape))
print("forward_finite", torch.isfinite(y).all().item())
print("backward_finite", torch.isfinite(x.grad).all().item())
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
