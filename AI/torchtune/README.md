# Quick reference

- The official Torchtune Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# Torchtune | openEuler

Current Torchtune docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[Torchtune](https://github.com/meta-pytorch/torchtune) is a PyTorch-native library for easily authoring, fine-tuning and experimenting with large language models. It provides hackable recipes (LoRA, QLoRA, full fine-tune, knowledge distillation) with composable configs and the `tune` CLI on top of native PyTorch.

This image ships Torchtune with [torch_npu](https://atomgit.com/ascend/pytorch) so that recipes run seamlessly on the Ascend NPU (`device=npu`). The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.11.0` and `torch_npu==2.11.0.post2` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/torchtune/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the Torchtune documentation at [pytorch.org/torchtune](https://pytorch.org/torchtune/).

# Supported tags and respective Dockerfile links

The tag of each Torchtune docker image consists of the Torchtune version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.6.1-torch_npu2.11.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/torchtune/0.6.1-torch_npu2.11.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| Torchtune 0.6.1 (torch_npu 2.11.0.post2, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the torchtune image
export IMAGE=openeuler/torchtune:0.6.1-torch_npu2.11.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name torchtune \
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

## Quick start 3: LoRA fine-tuning on Ascend NPU

Validate the environment and the `tune` CLI inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
python3 -c "import torchtune; print('torchtune', torchtune.__version__)"
tune --help
```

Download the base model from the ModelScope mirror:

```bash
python3 -c "from modelscope import snapshot_download; print(snapshot_download('Qwen/Qwen2.5-0.5B-Instruct'))"
```

Write a few alpaca-format samples to `data.json` (the quick start uses 50):

```json
[
  {"instruction": "Briefly explain why the sky looks blue.", "input": "", "output": "The sky appears blue because shorter-wavelength sunlight is scattered in all directions by the gases in Earth's atmosphere."},
  {"instruction": "Name a prime number below ten.", "input": "", "output": "7"},
  {"instruction": "Translate 'hello' into Spanish.", "input": "", "output": "Hola"},
  {"instruction": "What is the capital of France?", "input": "", "output": "Paris"},
  {"instruction": "Compute 12 times 13.", "input": "", "output": "156"},
  {"instruction": "Who wrote 'Pride and Prejudice'?", "input": "", "output": "Jane Austen"},
  {"instruction": "Give a synonym for 'happy'.", "input": "", "output": "Joyful"},
  {"instruction": "What is the boiling point of water in Celsius?", "input": "", "output": "100"}
]
```

Run 3 steps of single-device LoRA fine-tuning (`<model_path>` is the path printed by `snapshot_download`):

```bash
ASCEND_RT_VISIBLE_DEVICES=0 tune run lora_finetune_single_device \
  --config qwen2_5/0.5B_lora_single_device \
  device=npu \
  checkpointer.checkpoint_dir="<model_path>" \
  tokenizer.path="<model_path>/vocab.json" \
  tokenizer.merges_file="<model_path>/merges.txt" \
  dataset=torchtune.datasets.alpaca_dataset \
  dataset.source=json \
  dataset.data_files="${PWD}/data.json" \
  metric_logger=torchtune.training.metric_logging.StdoutLogger \
  ~metric_logger.log_dir \
  log_peak_memory_stats=False \
  output_dir="${PWD}/output" \
  max_steps_per_epoch=3 \
  epochs=1 \
  log_every_n_steps=1
```

After training, the LoRA adapter is written to the epoch folder under `output/` as `adapter_config.json` + `adapter_model.pt` (the base weights are untouched).

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
