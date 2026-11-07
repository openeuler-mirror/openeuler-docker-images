# Quick reference

- The official TensorDict Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# TensorDict | openEuler

Current TensorDict docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[TensorDict](https://github.com/pytorch/tensordict) is a PyTorch ecosystem library providing a dictionary-like container that behaves like a tensor: batched indexing and slicing, stacking and concatenation, device moves, nested structures, `@tensorclass` dataclasses, parameter serialization and memory-mapped storage. It is the data backbone of TorchRL and other functional programming workloads.

TensorDict supports the Ascend NPU through [torch_npu](https://atomgit.com/ascend/pytorch): every TensorDict operation (construction, indexing, stacking, `.to(device)`, memmap storage, module forward) is built on `torch.Tensor`, which torch_npu routes to the NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.11.0` and `torch_npu==2.11.0.post2` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/tensordict/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the TensorDict documentation at [pytorch.org/tensordict](https://pytorch.org/tensordict/).

# Supported tags and respective Dockerfile links

The tag of each TensorDict docker image consists of the TensorDict version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|
|[0.15.5-torch_npu2.11.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/tensordict/0.15.5-torch_npu2.11.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| TensorDict 0.15.5 (torch_npu 2.11.0.post2, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the tensordict image
export IMAGE=openeuler/tensordict:0.15.5-torch_npu2.11.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-tensordict \
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

## Quick start 3: build a TensorDict on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
```

Construct a `TensorDict` directly on `npu:0` and exercise the core dictionary and tensor-like semantics:

```bash
python3 -c "
import torch, torch_npu
from tensordict import TensorDict
td = TensorDict(source={'obs': torch.zeros(3, 4), 'action': torch.zeros(3, 2)}, batch_size=[3], device='npu:0')
print('type', type(td).__name__)
print('device', td.device)
print('keys', sorted(td.keys()))
td.set('reward', torch.ones(3, device='npu:0'))
print('reward sum', td['reward'].sum().item())
print('td + 1 obs sum', (td + 1)['obs'].sum().item())
"
```

Nested TensorDicts, `TensorDictParams`, `make_tensordict`, `@tensorclass` and memmap-backed storage all work the same way on the NPU device.

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
