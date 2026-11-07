# Quick reference

- The official ComfyUI Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# ComfyUI | openEuler

Current ComfyUI docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[ComfyUI](https://github.com/comfyanonymous/ComfyUI) is an open-source node-based interface for diffusion models. It provides a modular graph editor to assemble image, video and audio generation workflows, and exposes the same workflows through an HTTP API on port 8188.

This image ships ComfyUI with [torch_npu](https://atomgit.com/ascend/pytorch) so that diffusion models run seamlessly on the Ascend NPU: ComfyUI detects `torch_npu` automatically and selects the `npu` device, no extra launch arguments are required. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/comfyui/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the ComfyUI documentation at [docs.comfy.org](https://docs.comfy.org/).

# Supported tags and respective Dockerfile links

The tag of each ComfyUI docker image consists of the ComfyUI version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.44.0-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/comfyui/0.44.0-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| ComfyUI 0.44.0 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the comfyui image
export IMAGE=openeuler/comfyui:0.44.0-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name comfyui \
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
-p 8188:8188 \
-d $IMAGE
```

The interactive web UI is now available at `http://<host>:8188`.

## Quick start 3: text-to-image on Ascend NPU

Validate the environment inside the container:

```bash
docker exec comfyui python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
```

Download the Stable Diffusion 1.5 checkpoint from ModelScope, link it into `models/checkpoints/` and run the upstream API example (default text-to-image workflow: SD 1.5, 512x512, 20 steps euler):

```bash
docker exec -it comfyui bash
```

```bash
python3 -c "from modelscope import snapshot_download; print(snapshot_download('AI-ModelScope/stable-diffusion-v1-5', revision='master', allow_patterns=['v1-5-pruned-emaonly.safetensors']))"
ln -sf /root/.cache/modelscope/hub/models/AI-ModelScope/stable-diffusion-v1-5/v1-5-pruned-emaonly.safetensors models/checkpoints/
python3 script_examples/basic_api_example.py
ls output/ComfyUI_*.png
```

The generated image is written to `output/ComfyUI_00001_.png`. Confirm that ComfyUI picked the NPU device:

```bash
python3 -c "import comfy.model_management as mm; print('comfy device:', mm.get_torch_device())"
```

For faster model download in China, use the ModelScope channel (already installed in this image).

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
