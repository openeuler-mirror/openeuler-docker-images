# Quick reference

- The official VBench Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# VBench | openEuler

Current VBench docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[VBench](https://github.com/Vchitect/VBench) is a comprehensive benchmark suite for video generation models. It decomposes video generation quality into multiple dimensions (subject consistency, motion smoothness, aesthetic quality, human action, etc.), provides the official UMT/CLIP-based evaluators and a `vbench evaluate` CLI to score generated videos.

This image ships VBench with [torch_npu](https://atomgit.com/ascend/pytorch) on top of the Ascend software stack. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/vbench/docs/Quick-start-Ascend.md). The guard runs the official README `human_action` example on `npu:0` with small Ascend device-selection patches applied on top of upstream; upstream VBench has no native NPU device scheduling yet.

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the VBench documentation at [github.com/Vchitect/VBench](https://github.com/Vchitect/VBench#readme).

# Supported tags and respective Dockerfile links

The tag of each VBench docker image consists of the VBench version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.1.5-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vbench/0.1.5-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| VBench 0.1.5 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the vbench image
export IMAGE=openeuler/vbench:0.1.5-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name vbench \
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

## Quick start 3: validate the installation on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
```

Confirm that VBench and its video decoding stack are importable and the CLI works:

```bash
python3 -c "import decord, vbench; from importlib.metadata import version; print('vbench', version('vbench')); print('Decord', decord.__version__)"
vbench evaluate --help
```

To evaluate videos on the NPU, follow the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/vbench/docs/Quick-start-Ascend.md): it applies the Ascend device-selection patches to the VBench source, loads the official UMT `l16_ptk710_ftk710_ftk400_f16_res224.pth` checkpoint and runs the `human_action` dimension of the official LaVie sample videos with `--device npu:0`:

```bash
vbench evaluate \
    --videos_path <path-to-lavie-videos> \
    --dimension human_action \
    --device npu:0 \
    --full_json_dir <path-to-full-info-json> \
    --output_path ./output/vbench
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
