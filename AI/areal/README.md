# Quick reference

- The official AReaL Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# AReaL | openEuler

Current AReaL docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[AReaL](https://github.com/areal-project/AReaL) is an open-source, large-scale asynchronous reinforcement learning system for LLM post-training. It decouples rollout generation from training, supports RLHF/RLVR and agentic RL workflows, and scales from a single node to large clusters with fully/partially/asynchronous rollout modes.

This image ships AReaL with [torch_npu](https://atomgit.com/ascend/pytorch) so that post-training runs seamlessly on the Ascend NPU. The software stack is validated on Ascend 910B4 cards with CANN 9.1.0, `torch==2.10.0` and `torch_npu==2.10.0.post6` on Python 3.12, following the Ascend examples guard of the workflows repo ([project scripts](https://github.com/cosdt-ci-test/workflows/tree/main/projects/areal/scripts)).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the AReaL documentation at [areal-project.github.io/AReaL](https://areal-project.github.io/AReaL/en/intro.html).

# Supported tags and respective Dockerfile links

The tag of each AReaL docker image consists of the AReaL version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[2.1.1-torch_npu2.10.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/areal/2.1.1-torch_npu2.10.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| AReaL 2.1.1 (torch_npu 2.10.0.post6, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the areal image
export IMAGE=openeuler/areal:2.1.1-torch_npu2.10.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-areal \
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

## Quick start 3: validate the training environment on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
python3 -c "from importlib.metadata import version; print('areal', version('areal'))"
areal --help
```

The AReaL source tree (with `examples/`) is installed at `/opt/AReaL`. Run a GSM8K SFT smoke test the same way the Ascend CI does (single NPU, `Qwen/Qwen3-1.7B` as the actor, FSDP training backend; the model and dataset are downloaded at runtime, use the HF mirror in China):

```bash
cd /opt/AReaL
export HF_ENDPOINT=https://hf-mirror.com
export SWANLAB_MODE=disabled
python3 examples/math/gsm8k_sft.py --config examples/math/gsm8k_sft.yaml \
    scheduler.type=local \
    cluster.n_gpus_per_node=1 \
    actor.backend=fsdp:d1p1t1 \
    actor.path=Qwen/Qwen3-1.7B \
    experiment_name=areal-sft-smoke \
    train_dataset.batch_size=2 \
    valid_dataset.batch_size=2 \
    +total_train_steps=1 \
    +train_dataset.setup_timeout=600 \
    +valid_dataset.setup_timeout=600 \
    stats_logger.wandb.mode=disabled
```

The vLLM rollout engine and the Megatron training backend are not bundled in this image; install the matched vLLM-Ascend stack and follow the upstream NPU guides before running rollout-backed examples.

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
