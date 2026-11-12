# Quick reference

- The official MMEngine Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# MMEngine | openEuler

Current MMEngine docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[MMEngine](https://github.com/open-mmlab/mmengine) is OpenMMLab's foundational library for training deep learning models. It provides the universal `Runner` training loop, a pythonic config system with inheritance and interpolation, registries, hooks, evaluators and logging/visualization/file IO utilities, powering all OpenMMLab projects such as MMDetection and MMPretrain.

MMEngine natively supports the Ascend NPU: `mmengine.device.get_device()` returns `npu` when [torch_npu](https://atomgit.com/ascend/pytorch) is present, `AmpOptimWrapper` switches to `torch.npu.amp.GradScaler`, and the `torch_npu.optim` fused optimizers (e.g. `NpuFusedAdamW`) are registered automatically. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/mmengine/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the MMEngine documentation at [mmengine.readthedocs.io](https://mmengine.readthedocs.io/).

# Supported tags and respective Dockerfile links

The tag of each MMEngine docker image consists of the MMEngine version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|
|[0.10.7-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/mmengine/0.10.7-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| MMEngine 0.10.7 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the mmengine image
export IMAGE=openeuler/mmengine:0.10.7-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-mmengine \
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

## Quick start 3: NPU device abstraction and mixed precision on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
python3 -c "import mmengine, mmengine.runner, mmengine.hooks, mmengine.visualization; print('mmengine subpackages ok')"
```

Confirm that MMEngine selects the `npu` device and that `autocast` works on the NPU:

```python
import torch
import torch_npu

from mmengine.device import get_device, is_npu_available
from mmengine.runner import amp

print('get_device:', get_device())
print('is_npu_available:', is_npu_available())
print('npu_count:', torch.npu.device_count())

linear = torch.nn.Linear(8, 2).to('npu')
with amp.autocast(device_type='npu', dtype=torch.float16):
    x = torch.randn(4, 8, device='npu')
    y = linear(x)
print('autocast_dtype:', y.dtype)
print('autocast_device:', y.device)
```

`Runner` uses the same mechanism to place models on the NPU (`model.to(get_device())`), so no device field is needed in the training config.

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
