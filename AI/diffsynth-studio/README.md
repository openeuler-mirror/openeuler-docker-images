# Quick reference

- The official DiffSynth-Studio Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# DiffSynth-Studio | openEuler

Current DiffSynth-Studio docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[DiffSynth-Studio](https://github.com/modelscope/DiffSynth-Studio) is an open-source diffusion-model engine from the ModelScope team. It supports inference and training of mainstream diffusion architectures (Stable Diffusion, SDXL, FLUX, etc.) through a unified pipeline API.

This image ships the PyPI `diffsynth` package with [torch_npu](https://atomgit.com/ascend/pytorch): `diffsynth.core.device` detects `torch_npu` and selects the `npu` device automatically, so models run seamlessly on the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/diffsynth-studio/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the DiffSynth-Studio documentation at [github.com/modelscope/DiffSynth-Studio](https://github.com/modelscope/DiffSynth-Studio/tree/main/docs).

# Supported tags and respective Dockerfile links

The tag of each DiffSynth-Studio docker image consists of the DiffSynth version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[2.2.0-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/diffsynth-studio/2.2.0-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| DiffSynth 2.2.0 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the diffsynth-studio image
export IMAGE=openeuler/diffsynth-studio:2.2.0-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name diffsynth-studio \
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

## Quick start 3: generate an image on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
```

Generate a 512x512 image with Stable Diffusion 1.5 on the NPU (the model is downloaded from ModelScope on first use, `num_inference_steps=5` keeps the first run short):

```python
import torch
from diffsynth.core import ModelConfig
from diffsynth.core.device.npu_compatible_device import get_device_name
from diffsynth.pipelines.stable_diffusion import StableDiffusionPipeline

print("device_name", get_device_name())
pipe = StableDiffusionPipeline.from_pretrained(
    torch_dtype=torch.float32,
    device="npu",
    model_configs=[
        ModelConfig(model_id="AI-ModelScope/stable-diffusion-v1-5", origin_file_pattern="text_encoder/model.safetensors"),
        ModelConfig(model_id="AI-ModelScope/stable-diffusion-v1-5", origin_file_pattern="unet/diffusion_pytorch_model.safetensors"),
        ModelConfig(model_id="AI-ModelScope/stable-diffusion-v1-5", origin_file_pattern="vae/diffusion_pytorch_model.safetensors"),
    ],
    tokenizer_config=ModelConfig(model_id="AI-ModelScope/stable-diffusion-v1-5", origin_file_pattern="tokenizer/"),
)
print("unet.device", next(pipe.unet.parameters()).device)
image = pipe(
    prompt="a photo of an astronaut riding a horse on mars, high quality, detailed",
    negative_prompt="blurry, low quality, deformed",
    cfg_scale=7.5,
    height=512,
    width=512,
    seed=42,
    rand_device="npu",
    num_inference_steps=5,
)
image.save("image.jpg")
print("image_size", image.size)
```

`unet.device npu:0` confirms that the weights are placed on the Ascend device. Increase the steps to 50 for higher quality once the pipeline is verified.

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
