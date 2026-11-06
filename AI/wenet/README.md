# Quick reference

- The official WeNet Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# WeNet | openEuler

Current WeNet docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[WeNet](https://github.com/wenet-e2e/wenet) is a production-focused open-source speech recognition toolkit. It provides streaming and non-streaming end-to-end ASR in a unified two-pass (U2) framework, supports the conformer, transformer and U2++ architectures, and ships complete training, decoding and runtime deployment stacks.

This image ships WeNet with [torch_npu](https://atomgit.com/ascend/pytorch): training and inference are scheduled on the Ascend NPU through `torch_npu`, and the official `examples/aishell/s0/run_npu.sh` recipe auto-detects NPU devices and exports the required environment variables. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/wenet/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the WeNet documentation at [wenet.org.cn](https://wenet.org.cn/wenet/).

# Supported tags and respective Dockerfile links

The tag of each WeNet docker image consists of the WeNet version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[3.1.0-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/wenet/3.1.0-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| WeNet 3.1.0 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the wenet image
export IMAGE=openeuler/wenet:3.1.0-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name wenet \
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
python3 -c "import importlib.metadata as m; print('wenet', m.version('wenet'))"
```

To train an ASR model on the NPU, follow the official NPU recipe used by the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/wenet/docs/Quick-start-Ascend.md): download the AISHELL-1 dataset (via ModelScope), then drive the staged pipeline with `run_npu.sh`, which selects the NPU devices automatically:

```bash
cd /wenet/examples/aishell/s0
bash run_npu.sh --stage -1 --stop_stage 3 --data /root/asr-data/OpenSLR/33
bash run_npu.sh --stage 4 --stop_stage 4 --train_config conf/train_conformer.yaml --data /root/asr-data/OpenSLR/33
ls exp/conformer/epoch_0.pt
```

The stages cover data download (−1), data preparation (0), CMVN/dictionary (1–3), training (4), averaged-model decoding (5) and Libtorch export (6).

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
