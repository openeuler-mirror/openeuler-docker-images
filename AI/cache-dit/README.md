# Quick reference

- The official Cache-DiT Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# Cache-DiT | openEuler

Current Cache-DiT docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[Cache-DiT](https://github.com/vipshop/cache-dit) is an inference acceleration library for Diffusion Transformers. It caches and reuses intermediate features to skip redundant computation across denoising steps, and supports context and tensor parallel generation, with Ascend-native attention backends (`_native_npu`, `_npu_fia`) built in.

This image ships Cache-DiT with [torch_npu](https://atomgit.com/ascend/pytorch) so that image generation runs seamlessly and faster on the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/cache-dit/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the Cache-DiT documentation at [github.com/vipshop/cache-dit](https://github.com/vipshop/cache-dit).

# Supported tags and respective Dockerfile links

The tag of each Cache-DiT docker image consists of the Cache-DiT version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[1.5.3-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/cache-dit/1.5.3-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| Cache-DiT 1.5.3 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the cache-dit image
export IMAGE=openeuler/cache-dit:1.5.3-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-cache-dit \
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

## Quick start 3: image generation on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available())"
python3 -c "import cache_dit; print('cache-dit version:', cache_dit.__version__)"
```

Download the FLUX.1-dev weights from the ModelScope mirror (about 28 GB) and generate an image with the Ascend-native attention backend on a single card:

```bash
export HF_ENDPOINT=https://hf-mirror.com
export PYTORCH_NPU_ALLOC_CONF=expandable_segments:True
python3 -c "from modelscope import snapshot_download; snapshot_download('AI-ModelScope/FLUX.1-dev', local_dir='/root/.cache/modelscope/cache-dit-flux')"
python3 -m cache_dit.generate flux \
  --model-path /root/.cache/modelscope/cache-dit-flux \
  --attn _native_npu \
  --cpu-offload \
  --prompt "A cat holding a sign that says hello world" \
  --num_inference_steps 10 \
  --height 512 \
  --width 512 \
  --save-path output/test.png
```

The output image is written to `output/test.png` and the log prints the load and inference time. Adding `--cache` enables the feature cache on top of the NPU attention backend, and multi-card runs use `torchrun --nproc_per_node=4 -m cache_dit.generate flux --parallel ulysses --attn _native_npu ...`.

For faster model download in China, use the ModelScope or hf-mirror channel:

```bash
export HF_ENDPOINT=https://hf-mirror.com
# or
pip install modelscope
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
