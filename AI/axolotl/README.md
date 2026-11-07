# Quick reference

- The official Axolotl Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# Axolotl | openEuler

Current Axolotl docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[Axolotl](https://github.com/axolotl-ai-cloud/axolotl) is an open-source tool designed to simplify the fine-tuning of large language models. It supports LoRA/QLoRA, full-parameter fine-tuning and a wide range of alignment algorithms through YAML-driven configurations and a single CLI (`axolotl train`).

This image ships Axolotl with [torch_npu](https://atomgit.com/ascend/pytorch) so that fine-tuning runs seamlessly on the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.11.0` and `torch_npu==2.11.0.post2` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/axolotl/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the Axolotl documentation at [docs.axolotl.ai](https://docs.axolotl.ai/).

# Supported tags and respective Dockerfile links

The tag of each Axolotl docker image consists of the Axolotl version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.21.1-torch_npu2.11.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/axolotl/0.21.1-torch_npu2.11.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| Axolotl 0.21.1 (torch_npu 2.11.0.post2, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the axolotl image
export IMAGE=openeuler/axolotl:0.21.1-torch_npu2.11.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-axolotl \
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

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
```

Run a 3-step LoRA fine-tuning of `Qwen/Qwen2.5-0.5B-Instruct` (downloaded from ModelScope, no Hugging Face token required). Download the model and prepare the working directory:

```bash
mkdir -p /root/axolotl-qs
ln -s "$(python3 -c 'from modelscope import snapshot_download; print(snapshot_download("Qwen/Qwen2.5-0.5B-Instruct"))' | grep '^/' | tail -n 1)" /root/axolotl-qs/model
```

Save the training data as `/root/axolotl-qs/tiny_alpaca.jsonl`:

```json
{"instruction": "Translate to English.", "input": "你好", "output": "Hello"}
{"instruction": "Name a color.", "input": "", "output": "Blue"}
{"instruction": "Add the numbers.", "input": "2 and 3", "output": "5"}
{"instruction": "Say yes or no.", "input": "", "output": "Yes"}
```

Save the LoRA configuration as `/root/axolotl-qs/lora-npu.yml`. On Ascend use `attn_implementation: eager`, `optimizer: adamw_torch` and disable the CUDA-only `lora_*_kernel` flags:

```yaml
base_model: /root/axolotl-qs/model
model_type: AutoModelForCausalLM
tokenizer_type: AutoTokenizer
load_in_8bit: false
load_in_4bit: false
strict: false
datasets:
  - path: /root/axolotl-qs/tiny_alpaca.jsonl
    type: alpaca
    ds_type: json
dataset_prepared_path: /root/axolotl-qs/prepared
val_set_size: 0
output_dir: /root/axolotl-qs/outputs
sequence_len: 256
sample_packing: false
pad_to_sequence_len: false
adapter: lora
lora_r: 8
lora_alpha: 16
lora_dropout: 0.05
lora_target_linear: true
gradient_accumulation_steps: 1
micro_batch_size: 1
num_epochs: 1
max_steps: 3
optimizer: adamw_torch
lr_scheduler: cosine
learning_rate: 0.0002
bf16: true
tf32: false
gradient_checkpointing: true
flash_attention: false
attn_implementation: eager
lora_mlp_kernel: false
lora_qkv_kernel: false
lora_o_kernel: false
lora_embedding_kernel: false
logging_steps: 1
warmup_steps: 0
saves_per_epoch: 1
save_total_limit: 1
trust_remote_code: false
```

Train with the plain `python` launcher (the default `accelerate` launcher looks for CUDA):

```bash
axolotl train /root/axolotl-qs/lora-npu.yml --launcher python
```

The printed configuration contains `"device": "npu:0"` and the run ends with `Training completed!`.

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
