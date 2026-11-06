# Quick reference

- The official LightX2V Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# LightX2V | openEuler

Current LightX2V docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[LightX2V](https://github.com/ModelTC/LightX2V) is a lightweight inference framework for image and video generation. It supports DiT models such as Wan with high-performance kernels, quantization and out-of-the-box platform configurations, and ships a `LightX2VPipeline` Python API for text-to-video generation.

This image ships LightX2V with [torch_npu](https://atomgit.com/ascend/pytorch) so that video generation runs seamlessly on the Ascend NPU. LightX2V is not published on PyPI, so the release source tree is cloned to `/opt/LightX2V` and installed from there; the `ascend_npu` backend is preselected through the `PLATFORM` environment variable. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/lightx2v/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the LightX2V documentation at [github.com/ModelTC/LightX2V](https://github.com/ModelTC/LightX2V).

# Supported tags and respective Dockerfile links

The tag of each LightX2V docker image consists of the LightX2V version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.6.0-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/lightx2v/0.6.0-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| LightX2V 0.6.0 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the lightx2v image
export IMAGE=openeuler/lightx2v:0.6.0-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-lightx2v \
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

## Quick start 3: text-to-video on Ascend NPU

Validate the environment inside the container (the image already sets `PLATFORM=ascend_npu`):

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available())"
python3 -c "from importlib.metadata import version; print('lightx2v', version('lightx2v'))"
```

Generate a short video with [Wan2.1-T2V-1.3B](https://modelscope.cn/models/Wan-AI/Wan2.1-T2V-1.3B) (the model is about 17.6 GB and is downloaded from ModelScope automatically). Run the following Python script:

```python
import os
import time

# LightX2V selects the backend through the PLATFORM environment variable,
# which must be set before importing lightx2v (the image sets it already).
os.environ["PLATFORM"] = "ascend_npu"

from modelscope import snapshot_download

from lightx2v import LightX2VPipeline

model_path = None
for attempt in range(3):
    try:
        model_path = snapshot_download('Wan-AI/Wan2.1-T2V-1.3B')
        break
    except Exception as exc:
        print('download attempt %d/3 failed: %s' % (attempt + 1, exc))
        time.sleep(10)
assert model_path, 'Wan2.1-T2V-1.3B download failed after 3 attempts'

pipe = LightX2VPipeline(
    model_path=model_path,
    model_cls='wan2.1',
    task='t2v',
)
pipe.create_generator(config_json='/opt/LightX2V/configs/platforms/ascend_npu/wan_t2v.json')

prompt = "Two anthropomorphic cats in comfy boxing gear and bright gloves fight intensely on a spotlighted stage."
negative_prompt = "色调艳丽，过曝，静态，细节模糊不清，字幕，风格，作品，画作，画面，静止，整体发灰，最差质量，低质量，JPEG压缩残留，丑陋的，残缺的，多余的手指，画得不好的手部，画得不好的脸部，畸形的，毁容的，形态畸形的肢体，手指融合，静止不动的画面，杂乱的背景，三条腿，背景人很多，倒着走"
save_result_path = "save_results/output_lightx2v_wan_t2v.mp4"

pipe.generate(
    seed=42,
    prompt=prompt,
    negative_prompt=negative_prompt,
    save_result_path=save_result_path,
)
print(f'saved: {save_result_path}')
```

The generated MP4 file is written to `save_results/output_lightx2v_wan_t2v.mp4`.

For faster model download in China, use the ModelScope or hf-mirror channel:

```bash
export HF_ENDPOINT=https://hf-mirror.com
# or
pip install modelscope
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
