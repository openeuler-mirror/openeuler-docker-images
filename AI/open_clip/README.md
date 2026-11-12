# Quick reference

- The official open_clip Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# open_clip | openEuler

Current open_clip docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[open_clip](https://github.com/mlfoundations/open_clip) is an open source community implementation of OpenAI's CLIP, supporting hundreds of pretrained image-text models, zero-shot classification, and custom training on your own data. `open_clip.create_model_and_transforms` builds a model and its preprocessing transform, `open_clip.get_tokenizer` builds the matching text tokenizer, and the `open_clip_train` entry point supports large-scale contrastive training.

This image ships open_clip with [torch_npu](https://atomgit.com/ascend/pytorch) so that models run seamlessly on the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/open_clip/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the open_clip documentation at [github.com/mlfoundations/open_clip](https://github.com/mlfoundations/open_clip).

# Supported tags and respective Dockerfile links

The tag of each open_clip docker image consists of the open_clip version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[4.2.1-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/open_clip/4.2.1-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| open_clip 4.2.1 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the open_clip image
export IMAGE=openeuler/open_clip:4.2.1-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-open_clip \
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

## Quick start 3: image-text similarity on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
python3 -c "import open_clip; print('open_clip', open_clip.__version__)"
```

Compute image-text similarity with a pretrained `ViT-B-32` on the NPU — this follows the upstream README example and only adds `torch_npu` and `device="npu:0"`:

```python
import torch
import torch_npu
from PIL import Image
import open_clip

device = "npu:0"
labels = ["a diagram", "a dog", "a cat"]

model, _, preprocess = open_clip.create_model_and_transforms(
    "ViT-B-32",
    pretrained="laion2b_s34b_b79k",
    device=device,
)
model.eval()
tokenizer = open_clip.get_tokenizer("ViT-B-32")

# any image works here; a solid-color PIL image keeps the example self-contained
image = preprocess(Image.new("RGB", (512, 512), (30, 144, 255))).unsqueeze(0).to(device)
text = tokenizer(labels).to(device)

with torch.no_grad():
    image_features = model.encode_image(image)
    text_features = model.encode_text(text)
    image_features /= image_features.norm(dim=-1, keepdim=True)
    text_features /= text_features.norm(dim=-1, keepdim=True)
    probabilities = (100.0 * image_features @ text_features.T).softmax(dim=-1)

print("device:", next(model.parameters()).device)
print("top label:", labels[probabilities.argmax(dim=-1).item()])
print("NPU inference PASSED")
```

For faster weight download in China, use the ModelScope or hf-mirror channel:

```bash
export HF_ENDPOINT=https://hf-mirror.com
# or
pip install modelscope
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
