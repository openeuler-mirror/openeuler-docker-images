# Quick reference

- The official slime Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# slime | openEuler

Current slime docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[slime](https://github.com/THUDM/slime) is an open-source RL training framework from THUDM designed for large-scale post-training of large language models. It supports synchronous/asynchronous agentic RL and RLHF workflows on top of SGLang inference engines and Megatron training backends.

This image ships the Ascend-adapted slime tree from the [Ascend/slime-ascend](https://gitcode.com/Ascend/slime-ascend) fork (upstream slime has no Ascend support) together with [torch_npu](https://atomgit.com/ascend/pytorch), so training runs seamlessly on the Ascend NPU. The software stack is validated on Ascend 910B4 cards with CANN 9.1.0, `torch==2.10.0` and `torch_npu==2.10.0.post6` on Python 3.12, following the Ascend examples guard of the workflows repo ([quick start runbook](https://github.com/cosdt-ci-test/workflows/blob/main/projects/slime/docs/Quick-start-Ascend.md) and [setup scripts](https://github.com/cosdt-ci-test/workflows/tree/main/projects/slime/scripts)).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the slime repository at [github.com/THUDM/slime](https://github.com/THUDM/slime).

# Supported tags and respective Dockerfile links

The tag of each slime docker image consists of the slime version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.4.0-torch_npu2.10.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/slime/0.4.0-torch_npu2.10.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| slime 0.4.0, Ascend-adapted fork at c69676f (torch_npu 2.10.0.post6, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the slime image
export IMAGE=openeuler/slime:0.4.0-torch_npu2.10.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-slime \
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
python3 -c "import slime; print('slime:', slime.__file__)"
```

The slime source tree (with the `examples/` directory of the Ascend fork) is installed at `/opt/slime-ascend`. Run a minimal asynchronous RL recipe the same way the Ascend CI does (four NPUs, `Qwen/Qwen2.5-0.5B-Instruct` from ModelScope, two rollouts):

```bash
cd /opt/slime-ascend
export PYTHONPATH=/opt/slime-ascend:$PYTHONPATH
bash examples/fully_async/run-qwen2.5-0.5B-fully_async.sh
```

The example script launches the Ray cluster and the SGLang rollout engines on the NPU and finishes after the configured rollouts plus optimizer steps. The SGLang and Megatron backends required by the rollout engines are not bundled in this image; follow the Ascend fork's `scripts/ascend_script/quick_install.sh` and the [Ascend quick start runbook](https://github.com/cosdt-ci-test/workflows/blob/main/projects/slime/docs/Quick-start-Ascend.md) to install the matched stack.

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
