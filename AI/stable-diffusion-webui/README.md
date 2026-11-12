# Quick reference

- The official stable-diffusion-webui Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# stable-diffusion-webui | openEuler

Current stable-diffusion-webui docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui) is a browser interface for Stable Diffusion based on the Gradio library. It provides text-to-image and image-to-image generation, inpainting, upscaling and many extensions, plus a REST API (`/sdapi/v1`) for headless usage.

This image ships stable-diffusion-webui with [torch_npu](https://atomgit.com/ascend/pytorch) so that Stable Diffusion runs seamlessly on the Ascend NPU; launch with `--skip-torch-cuda-test --no-half` as in the Ascend quick start. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/stable-diffusion-webui/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the stable-diffusion-webui documentation at [the official wiki](https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki).

# Supported tags and respective Dockerfile links

The tag of each stable-diffusion-webui docker image consists of the stable-diffusion-webui version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[1.10.1-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/stable-diffusion-webui/1.10.1-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| stable-diffusion-webui 1.10.1 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the stable-diffusion-webui image
export IMAGE=openeuler/stable-diffusion-webui:1.10.1-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name stable-diffusion-webui \
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
-p 7860:7860 \
-d $IMAGE
```

The web UI is available at `http://<host>:7860`. The first launch clones the Stable Diffusion runtime repositories into `repositories/` and needs access to `github.com`; later launches reuse them.

## Quick start 3: text-to-image through the REST API on Ascend NPU

Validate the environment inside the container:

```bash
docker exec stable-diffusion-webui python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
```

Download the `sd-turbo` checkpoint from ModelScope, restart the container with the checkpoint and generate an image through the API:

```bash
docker exec stable-diffusion-webui python3 -c "from modelscope import snapshot_download; from pathlib import Path; p = Path(snapshot_download('AI-ModelScope/sd-turbo')) / 'sd_turbo.safetensors'; assert p.is_file(); print(p)"
```

```bash
mkdir -p models && cp /path/to/sd_turbo.safetensors models/
docker run --rm \
--name stable-diffusion-webui \
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
-v $PWD/models:/stable-diffusion-webui/models/Stable-diffusion \
-p 7860:7860 \
-d $IMAGE --ckpt /stable-diffusion-webui/models/Stable-diffusion/sd_turbo.safetensors
```

Once the server is up, submit a text-to-image request (1 step, 512x512, as in the quick start):

```bash
curl -s http://localhost:7860/sdapi/v1/txt2img \
  -H 'Content-Type: application/json' \
  -d '{"prompt": "a cute cat", "steps": 1, "cfg_scale": 1.0, "width": 512, "height": 512}' \
  | python3 -c "import sys, json, base64; d = json.load(sys.stdin); open('/tmp/sd-turbo-out.png', 'wb').write(base64.b64decode(d['images'][0])); print('image saved to /tmp/sd-turbo-out.png')"
```

For faster model download in China, use the ModelScope channel (already installed in this image).

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
