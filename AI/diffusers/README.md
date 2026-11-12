# Quick reference

- The official Diffusers Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# Diffusers | openEuler

Current Diffusers docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[Diffusers](https://github.com/huggingface/diffusers) is the go-to Hugging Face library for diffusion models. `DiffusionPipeline.from_pretrained` assembles state-of-the-art text-to-image and image-to-image pipelines (Stable Diffusion and friends), schedulers such as `UniPCMultistepScheduler` control the speed/quality trade-off, `load_lora_weights` switches generation style, and `enable_model_cpu_offload` tames peak NPU memory for large models.

This image ships Diffusers with [torch_npu](https://atomgit.com/ascend/pytorch) so that models run seamlessly on the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/diffusers/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the Diffusers documentation at [huggingface.co/docs/diffusers](https://huggingface.co/docs/diffusers).

# Supported tags and respective Dockerfile links

The tag of each Diffusers docker image consists of the Diffusers version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.42.1-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/diffusers/0.42.1-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| Diffusers 0.42.1 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the diffusers image
export IMAGE=openeuler/diffusers:0.42.1-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-diffusers \
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

## Quick start 3: text to image on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
python3 -c "import diffusers; print('diffusers', diffusers.__version__)"
```

Generate an image with Stable Diffusion 1.5: `DiffusionPipeline.from_pretrained` assembles the text encoder, UNet, VAE, tokenizer and scheduler, and `.to("npu:0")` moves the pipeline onto the NPU:

```python
import torch
import torch_npu
from diffusers import DiffusionPipeline

pipe = DiffusionPipeline.from_pretrained(
    "stable-diffusion-v1-5/stable-diffusion-v1-5", dtype=torch.bfloat16, safety_checker=None,
).to("npu:0")

prompt = "a photo of an astronaut riding a horse on mars"
image = pipe(prompt, num_inference_steps=30).images[0]
image.save("astronaut_rides_horse.png")
print("generated:", image.size)
```

Swap the scheduler for faster generation with fewer steps — `UniPCMultistepScheduler.from_config` reuses the original scheduler config:

```python
from diffusers import UniPCMultistepScheduler

pipe.scheduler = UniPCMultistepScheduler.from_config(pipe.scheduler.config)
image = pipe(prompt, num_inference_steps=20).images[0]
image.save("astronaut_unipc.png")
print("generated:", image.size, "via", type(pipe.scheduler).__name__)
```

For faster model download in China, use the ModelScope or hf-mirror channel:

```bash
export HF_ENDPOINT=https://hf-mirror.com
# or
pip install modelscope
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
