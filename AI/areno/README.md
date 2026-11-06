# Quick reference

- The official AReno Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# AReno | openEuler

Current AReno docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[AReno](https://github.com/inclusionAI/AReno) is an easy-to-use and fast toolkit from inclusionAI to scale up RL post-training (RLVR and agentic RL) on a single node. Since v0.9.0 it ships a native Ascend NPU backend that compiles an Ascend C acceleration extension (`areno.accel._areno_accel_npu`) during installation, and both `areno train` and `areno serve` accept `--backend npu`.

This image ships AReno with [torch_npu](https://atomgit.com/ascend/pytorch) so that RL post-training runs seamlessly on the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.10.0` and `torch_npu==2.10.0.post6` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/areno/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the AReno documentation at [asystem-ai.io/docs/areno](https://asystem-ai.io/docs/areno/).

# Supported tags and respective Dockerfile links

The tag of each AReno docker image consists of the AReno version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.10.0-torch_npu2.10.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/areno/0.10.0-torch_npu2.10.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| AReno 0.10.0 (torch_npu 2.10.0.post6, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the areno image
export IMAGE=openeuler/areno:0.10.0-torch_npu2.10.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-areno \
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

## Quick start 3: RLVR training and serving on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
python3 -c "import importlib.util as u; specs = {m: u.find_spec(m) for m in ['areno', 'areno.accel', 'areno.accel._areno_accel_npu']}; [print(m, 'ok' if s is not None else 'MISSING') for m, s in specs.items()]"
areno train --help && areno serve --help
```

Run the tiny GSPO RLVR training smoke test on GSM8K with `Qwen/Qwen3-0.6B` (weights from the Hugging Face Hub, use the HF mirror in China):

```bash
cd /opt/AReno
source /usr/local/Ascend/ascend-toolkit/set_env.sh
export HF_ENDPOINT=https://hf-mirror.com
ASCEND_RT_VISIBLE_DEVICES=0 areno train \
  --ckpt Qwen/Qwen3-0.6B \
  --dataset-path openai/gsm8k:main \
  --model-hub hf \
  --dataset-loader-fn examples/math/dataset_loader.py \
  --reward-fn-path examples/math/math_verify_reward.py \
  --algo gspo \
  --backend npu \
  --attn-backend native \
  --tp-size 1 \
  --world-size 1 \
  --batch-size 1 \
  --max-steps 1 \
  --max-new-tokens 256 \
  --save-path outputs/qwen3-gspo \
  --save-interval 1
```

The log contains `stage=rollout_end`, `metric=reward_mean`, `train_stats=`, `stage=save_checkpoint_end` and `stage=max_steps_reached`, and the checkpoint lands in `outputs/qwen3-gspo/step_000001`. Serve the trained checkpoint through the OpenAI-compatible API:

```bash
source /usr/local/Ascend/ascend-toolkit/set_env.sh
ASCEND_RT_VISIBLE_DEVICES=0 areno serve \
  --model-path outputs/qwen3-gspo/step_000001 \
  --backend npu \
  --attn-backend native \
  --max-running-prompts 2 \
  --tp-size 1 \
  --world-size 1 \
  --port 8000
curl -fsS http://127.0.0.1:8000/v1/models
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
