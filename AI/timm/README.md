# Quick reference

- The official timm Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# timm | openEuler

Current timm docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[timm](https://github.com/huggingface/pytorch-image-models) (PyTorch Image Models) is a Hugging Face library of state-of-the-art computer vision models. It collects hundreds of pretrained image models (ResNet, ViT, EfficientNet, ConvNeXt, ...), with `timm.create_model` for classification and feature extraction and `features_only=True` turning any model into a multi-scale feature extractor.

This image ships timm with [torch_npu](https://atomgit.com/ascend/pytorch) so that models run seamlessly on the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/timm/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the timm documentation at [huggingface.co/docs/timm](https://huggingface.co/docs/timm).

# Supported tags and respective Dockerfile links

The tag of each timm docker image consists of the timm version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[1.0.31-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/timm/1.0.31-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| timm 1.0.31 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the timm image
export IMAGE=openeuler/timm:1.0.31-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-timm \
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

## Quick start 3: image classification on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
python3 -c "import timm; print('timm', timm.__version__)"
```

Create a model with `timm.create_model` and run a forward pass on the NPU:

```python
import timm
import torch
import torch_npu

model = timm.create_model("resnet18").to("npu:0").eval()
x = torch.randn(1, 3, 224, 224, device="npu:0")
with torch.no_grad():
    out = model(x)
print("out_shape", tuple(out.shape))
```

Load pretrained weights for real classification. Set `pretrained=True` (weights download from the Hugging Face hub at runtime) or load a local `model.safetensors` from the ModelScope mirror `timm/resnet18.a1_in1k`:

```python
import os

import safetensors.torch
import timm
import torch
import torch_npu

try:
    from modelscope.hub.snapshot_download import snapshot_download

    model_dir = snapshot_download("timm/resnet18.a1_in1k")
    model = timm.create_model("resnet18")
    model.load_state_dict(
        safetensors.torch.load_file(os.path.join(model_dir, "model.safetensors"))
    )
except Exception:
    os.environ.setdefault("HF_ENDPOINT", "https://hf-mirror.com")
    model = timm.create_model("resnet18", pretrained=True)

model = model.to("npu:0").eval()
x = torch.randn(1, 3, 224, 224, device="npu:0")
with torch.no_grad():
    out = model(x)
print("out_shape", tuple(out.shape))
```

`features_only=True` turns any model into a multi-scale feature extractor:

```python
model = timm.create_model("resnet18", features_only=True).to("npu:0").eval()
with torch.no_grad():
    outs = model(torch.randn(1, 3, 224, 224, device="npu:0"))
print("channels", model.feature_info.channels())
for i, o in enumerate(outs):
    print(i, tuple(o.shape))
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
