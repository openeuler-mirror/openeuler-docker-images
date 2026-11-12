# Quick reference

- The official OpenRLHF Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# OpenRLHF | openEuler

Current OpenRLHF docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[OpenRLHF](https://github.com/OpenRLHF/OpenRLHF) is an easy-to-use, scalable and high-performance RLHF framework based on DeepSpeed, Accelerate and Transformers. It provides SFT, reward modeling, PPO/DPO and other post-training pipelines through a unified CLI (`openrlhf.cli.*`).

This image ships OpenRLHF with [torch_npu](https://atomgit.com/ascend/pytorch) so that training runs seamlessly on the Ascend NPU: `torch.cuda` is mapped to the NPU via `torch_npu.contrib.transfer_to_npu`, and the OpenRLHF source tree is placed on `PYTHONPATH` because its PyPI wheel cannot install on aarch64. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.11.0` and `torch_npu==2.11.0.post2` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/openrlhf/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the OpenRLHF documentation at [openrlhf.readthedocs.io](https://openrlhf.readthedocs.io/).

# Supported tags and respective Dockerfile links

The tag of each OpenRLHF docker image consists of the OpenRLHF version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.11.2-torch_npu2.11.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/openrlhf/0.11.2-torch_npu2.11.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| OpenRLHF 0.11.2 (torch_npu 2.11.0.post2, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the openrlhf image
export IMAGE=openeuler/openrlhf:0.11.2-torch_npu2.11.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-openrlhf \
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

## Quick start 3: SFT with LoRA on Ascend NPU

Validate the environment inside the container (the image already maps `torch.cuda` to the NPU):

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
python3 -c "import torch; print(torch.zeros(1, device='cuda').device)"
python3 -c "import openrlhf; print(openrlhf.__file__)"
```

Run a 4-sample LoRA SFT of `Qwen/Qwen2.5-0.5B-Instruct` (downloaded from ModelScope, no Hugging Face token required). Download the model:

```bash
mkdir -p /root/openrlhf-qs
ln -s "$(python3 -c 'from modelscope import snapshot_download; print(snapshot_download("Qwen/Qwen2.5-0.5B-Instruct"))' | grep '^/' | tail -n 1)" /root/openrlhf-qs/model
```

Save the training data as `/root/openrlhf-qs/tiny_sft.jsonl`:

```json
{"question": "Translate to English: 你好", "response": "Hello"}
{"question": "Name a color.", "response": "Blue"}
{"question": "Add 2 and 3.", "response": "5"}
{"question": "Say yes or no.", "response": "Yes"}
```

Train with DeepSpeed for one epoch of LoRA (use `--ds.attn_implementation eager` and `--ds.adam_offload` on Ascend; do not enable `--ds.packing_samples`):

```bash
deepspeed --module openrlhf.cli.train_sft \
  --data.max_len 256 \
  --data.dataset /root/openrlhf-qs/tiny_sft.jsonl \
  --data.input_key question \
  --data.output_key response \
  --train.batch_size 1 \
  --train.micro_batch_size 1 \
  --data.max_samples 4 \
  --model.model_name_or_path /root/openrlhf-qs/model \
  --ckpt.output_dir /root/openrlhf-qs/ckpt \
  --ckpt.save_steps -1 \
  --logger.logging_steps 1 \
  --eval.steps -1 \
  --ds.zero_stage 2 \
  --ds.adam_offload \
  --train.max_epochs 1 \
  --ds.param_dtype bf16 \
  --ds.attn_implementation eager \
  --adam.lr 5e-6 \
  --ds.lora.rank 8 \
  --model.gradient_checkpointing_enable \
  --data.dataloader_num_workers 0
```

The log contains `device='npu'` and ends with `Train step of epoch 0: 100%` and `exits successfully.`.

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
