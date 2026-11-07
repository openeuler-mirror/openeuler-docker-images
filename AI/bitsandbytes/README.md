# Quick reference

- The official bitsandbytes Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# bitsandbytes | openEuler

Current bitsandbytes docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[bitsandbytes](https://github.com/bitsandbytes-foundation/bitsandbytes) is a lightweight library for quantizing large language models. It provides 8-bit optimizers, 8-bit matrix multiplication and the widely used NF4/FP4 `Linear4bit` layers, making quantized model inference and training possible on limited hardware.

Upstream does not officially support the Ascend NPU yet (see [issue #1847](https://github.com/bitsandbytes-foundation/bitsandbytes/issues/1847)). In this image the upstream default backend quantizes 4-bit weights on the CPU and runs the quantized matrix multiplication on the Ascend NPU, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/bitsandbytes/docs/Quick-start-Ascend.md). 8-bit training and 8-bit optimizers are not available on the NPU with the default backend. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12.

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the bitsandbytes documentation at [bitsandbytes.readthedocs.io](https://bitsandbytes.readthedocs.io/).

# Supported tags and respective Dockerfile links

The tag of each bitsandbytes docker image consists of the bitsandbytes version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|
|[0.50.2-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/bitsandbytes/0.50.2-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| bitsandbytes 0.50.2 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the bitsandbytes image
export IMAGE=openeuler/bitsandbytes:0.50.2-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-bitsandbytes \
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

## Quick start 3: NF4 Linear4bit forward on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
python3 -c "import bitsandbytes as bnb; import bitsandbytes.cextension as ce; print('bitsandbytes', bnb.__version__); print('BNB_BACKEND', ce.BNB_BACKEND)"
```

`BNB_BACKEND` prints `CPU` on Ascend: this is the expected upstream default backend, not a failure. The real NPU evidence is the `out.device` of the forward pass below.

Run an NF4 `Linear4bit` forward: the layer is created on the CPU, quantized when moved to `npu:0`, and executed with float16 inputs on the NPU.

```python
import torch
import torch_npu
import bitsandbytes as bnb

layer = bnb.nn.Linear4bit(
    64, 32, bias=False, compute_dtype=torch.float16, quant_type="nf4",
    compress_statistics=False,
)
layer = layer.to("npu:0")
x = torch.randn(4, 64, dtype=torch.float16, device="npu:0")
out = layer(x)
weight = layer.weight
print("weight.device", weight.device)
print("weight.bnb_quantized", weight.bnb_quantized)
print("out.device", out.device)
print("out.shape", tuple(out.shape))
print("NF4 forward on Ascend NPU: OK")
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
