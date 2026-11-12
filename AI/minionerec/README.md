# Quick reference

- The official MiniOneRec Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# MiniOneRec | openEuler

Current MiniOneRec docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[MiniOneRec](https://github.com/AkaliKong/MiniOneRec) is a fully open source generative recommendation framework covering the whole pipeline: Semantic ID (SID) construction, supervised fine-tuning (SFT) and recommendation-oriented RL. A decoder LLM is fine-tuned over SID sequences and evaluated with constrained beam search decoding, so only valid item IDs can be generated.

This image ships MiniOneRec with [torch_npu](https://atomgit.com/ascend/pytorch), keeping the upstream entry points (`sft.py`, `evaluate.py`, `rl.py`, `calc.py`) under `/opt/MiniOneRec`. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/minionerec/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/).

# Supported tags and respective Dockerfile links

The tag of each MiniOneRec docker image consists of the MiniOneRec version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0cbd94d-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/minionerec/0cbd94d-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| MiniOneRec 0cbd94d (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the minionerec image
export IMAGE=openeuler/minionerec:0cbd94d-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name minionerec \
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

## Quick start 3: generative recommendation on Ascend NPU

Load the CANN environment and check the device routing of the two entry points. `sft.py` leaves device selection to `TrainingArguments`, and the transformers device chain maps the NPU branch ahead of CUDA, so the trainer lands on `npu:0` without any injection:

```bash
source /usr/local/Ascend/ascend-toolkit/set_env.sh
cd /opt/MiniOneRec
python3 -c "
import torch, torch_npu
from transformers import TrainingArguments
print('npu available:', torch.npu.is_available())
print('trainer device:', TrainingArguments(output_dir='/tmp/probe-default').device)
"
```

The expected output is `npu available: True` and `trainer device: npu:0`.

For the evaluation and RL entry points (which hard-code `cuda`), enable the `torch_npu` CUDA-to-NPU shim through `PYTHONPATH` so only the target command is affected:

```bash
mkdir -p /tmp/minionerec-npu-shim
echo 'import torch_npu.contrib.transfer_to_npu  # noqa: F401' > /tmp/minionerec-npu-shim/sitecustomize.py
PYTHONPATH=/tmp/minionerec-npu-shim python3 -c "
import torch
print('with shim:', 'cuda' if torch.cuda.is_available() else 'cpu')
print('tensor landed on:', torch.zeros(1, device='cuda').device.type)
"
```

A full single-card run needs the base model and the preprocessed data. Download the Qwen2.5 base model from ModelScope and the Amazon Industrial_and_Scientific SID data via hf-mirror, then run one SFT epoch (see the [quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/minionerec/docs/Quick-start-Ascend.md) for the complete commands):

```bash
modelscope download --model Qwen/Qwen2.5-0.5B --local_dir ./Qwen2.5-0.5B
export HF_ENDPOINT=https://hf-mirror.com
python3 -c "from huggingface_hub import snapshot_download; snapshot_download(repo_id='kkknight/MiniOneRec', allow_patterns=['Amazon/index/*','Amazon/train/*','Amazon/valid/*','Amazon/test/*','Amazon/info/*'], local_dir='data')"
export ASCEND_RT_VISIBLE_DEVICES=0
export WANDB_MODE=disabled
python3 sft.py \
    --base_model ./Qwen2.5-0.5B \
    --train_file ./data/Amazon/train/Industrial_and_Scientific_5_2016-10-2018-11.csv \
    --eval_file ./data/Amazon/valid/Industrial_and_Scientific_5_2016-10-2018-11.csv \
    --output_dir ./smoke_out \
    --batch_size 8 --micro_batch_size 2 --num_epochs 1 \
    --cutoff_len 256 --sample 600 \
    --category Industrial_and_Scientific \
    --sid_index_path ./data/Amazon/index/Industrial_and_Scientific.index.json \
    --item_meta_path ./data/Amazon/index/Industrial_and_Scientific.item.json \
    --freeze_LLM False --train_from_scratch False
```

After SFT, `evaluate.py` (with the shim) runs constrained beam-search decoding on the test split, `calc.py` computes HR/NDCG/CC (CC, the number of invalid SID generations, must be 0), and `rl.py` runs GRPO on top of the SFT checkpoint. The constrained decoding and RL stages on NPU are covered step by step in the quick start guard.

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
