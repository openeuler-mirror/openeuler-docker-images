# Quick reference

- The official XTuner Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# XTuner | openEuler

Current XTuner docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[XTuner](https://github.com/InternLM/xtuner) is an efficient and flexible toolkit for fine-tuning large language and multimodal models. It provides ready-to-use configs, LoRA/QLoRA fine-tuning, checkpoint conversion/merging and a chat CLI on top of PyTorch and mmengine.

This image ships XTuner with [torch_npu](https://atomgit.com/ascend/pytorch) so that fine-tuning runs seamlessly on the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.11.0` and `torch_npu==2.11.0.post2` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/xtuner/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the XTuner documentation at [xtuner.readthedocs.io](https://xtuner.readthedocs.io/).

# Supported tags and respective Dockerfile links

The tag of each XTuner docker image consists of the XTuner version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.2.0-torch_npu2.11.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/xtuner/0.2.0-torch_npu2.11.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| XTuner 0.2.0 (torch_npu 2.11.0.post2, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the xtuner image
export IMAGE=openeuler/xtuner:0.2.0-torch_npu2.11.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name xtuner \
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

## Quick start 3: validate XTuner on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
python3 -c "import xtuner; from xtuner.version import __version__; print('xtuner', __version__)"
```

Check that the XTuner CLI entry points used by the quick start (`train`, `list-cfg`, `chat`) are available:

```bash
python3 -c "
from xtuner.entry_point import MODES
print('has_train:', 'train' in MODES)
print('has_list_cfg:', 'list-cfg' in MODES)
print('has_chat:', 'chat' in MODES)
"
xtuner list-cfg | head
```

The full Ascend fine-tuning flow (download `qwen/Qwen1.5-1.8B-Chat` weights from ModelScope, convert the Colorist instruction dataset to the OpenAI message format, copy and patch the `qwen1_5_1_8b_chat_qlora_custom_sft_e1` config, run single/double-card training, merge the LoRA adapter back and chat with `xtuner chat`) is available in the [Ascend quick start](https://github.com/cosdt-ci-test/workflows/blob/main/projects/xtuner/docs/Quick-start-Ascend.md). Training is launched with mmengine, for example:

```bash
TORCH_NPU_USE_HCCL=1 NPROC_PER_NODE=2 xtuner train <config_copy.py> --work-dir ./work_dirs
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
