# Quick reference

- The official ROLL Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# ROLL | openEuler

Current ROLL docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[ROLL](https://github.com/alibaba/ROLL) (Reinforcement Learning Optimization for Large-scale Learning) is Alibaba's open-source RL training framework. It supports SFT, DPO, PPO/GRPO, distillation and agentic RL pipelines over pluggable training strategies (FSDP2, Megatron) and rollout engines (vLLM), driven by Hydra YAML configurations.

This image ships ROLL with [torch_npu](https://atomgit.com/ascend/pytorch) and the vLLM-Ascend rollout stack, so training runs seamlessly on the Ascend NPU. The software stack is validated on Ascend 910B4 cards with CANN 9.1.0, `torch==2.10.0` and `torch_npu==2.10.0.post6` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/roll/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the ROLL documentation at [alibaba.github.io/ROLL](https://alibaba.github.io/ROLL/zh-Hans/).

# Supported tags and respective Dockerfile links

The tag of each ROLL docker image consists of the ROLL version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.4.0-torch_npu2.10.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/roll/0.4.0-torch_npu2.10.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| ROLL 0.4.0 (torch_npu 2.10.0.post6, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the roll image
export IMAGE=openeuler/roll:0.4.0-torch_npu2.10.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-roll \
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

## Quick start 3: agentic RL training on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu, vllm, vllm_ascend, triton; print('torch', torch.__version__); print('torch_npu', torch_npu.__version__); print('vllm', vllm.__version__); print('triton', triton.__version__); print('is_available:', torch.npu.is_available())"
```

Run the FrozenLake agentic RL quick start: `Qwen/Qwen2.5-0.5B-Instruct` acts as the policy model in a 4x4 frozen lake grid, and ROLL trains it for one step with the GRPO advantage estimator (the model is downloaded from ModelScope at runtime, no token required).

Save the following configuration as `/opt/ROLL/examples/agentic_frozen_lake_npu/quick_start_npu.yaml`:

```yaml
defaults:
  - ../config/traj_envs@_here_

hydra:
  run:
    dir: .
  output_subdir: null

exp_name: "roll-quick-start-npu"
seed: 42
logging_dir: ./output/logs
output_dir: ./output
render_save_dir: ./output/render
system_envs:
  USE_MODELSCOPE: '1'
  VLLM_ASCEND_ENABLE_NZ: '0'
  HCCL_NPU_SOCKET_PORT_RANGE: auto

track_with: tensorboard
tracker_kwargs:
  log_dir: ./output/tensorboard

num_gpus_per_node: 1

transfer_backend:
  backend_name: null

max_steps: 1
save_steps: 1000
logging_steps: 1
eval_steps: 1000
resume_from_checkpoint: false

rollout_batch_size: 8
val_batch_size: 2
sequence_length: 2048
max_tokens_per_step: 128

ppo_epochs: 1
adv_estimator: "grpo"
init_kl_coef: 0.0
whiten_advantages: true
entropy_loss_coef: 0

pretrain: Qwen/Qwen2.5-0.5B-Instruct
reward_pretrain: Qwen/Qwen2.5-0.5B-Instruct

actor_train:
  model_args:
    attn_implementation: fa2
    disable_gradient_checkpointing: false
    dtype: bf16
    model_type: ~
  training_args:
    learning_rate: 1.0e-6
    per_device_train_batch_size: 1
    gradient_accumulation_steps: 2
  data_args:
    template: qwen2_5
  strategy_args:
    strategy_name: fsdp2_train
    strategy_config:
      fsdp_size: 1
      param_dtype: bf16
      reduce_dtype: bf16
      reshard_after_forward: true
      offload_policy: false
      use_batched_model_update: false
  device_mapping: list(range(0,1))
  infer_batch_size: 1

actor_infer:
  model_args:
    disable_gradient_checkpointing: true
    dtype: bf16
  generating_args:
    max_new_tokens: 128
    temperature: 0.99
    num_return_sequences: 1
  data_args:
    template: qwen2_5
  strategy_args:
    strategy_name: vllm
    strategy_config:
      gpu_memory_utilization: 0.8
      block_size: 16
      load_format: auto
  device_mapping: list(range(0,1))
  infer_batch_size: 1

reference:
  model_args:
    attn_implementation: fa2
    disable_gradient_checkpointing: true
    dtype: bf16
    model_type: ~
  data_args:
    template: qwen2_5
  strategy_args:
    strategy_name: hf_infer
    strategy_config: ~
  device_mapping: list(range(0,1))
  infer_batch_size: 1

train_env_manager:
  max_env_num_per_worker: 8
  num_env_groups: 4
  group_size: 2
  tags: [FrozenLake]
  num_groups_partition: [4]

val_env_manager:
  max_env_num_per_worker: 2
  num_env_groups: 2
  group_size: 1
  tags: [FrozenLake]
  num_groups_partition: [2]

custom_envs:
  FrozenLake:
    ${custom_env.FrozenLake}
```

Launch the agentic pipeline (ROLL starts the Ray cluster automatically):

```bash
cd /opt
python3 ROLL/examples/start_agentic_pipeline.py --config_path agentic_frozen_lake_npu --config_name quick_start_npu
```

After training, the TensorBoard metrics are written to `output/tensorboard/roll-quick-start-npu`:

```python
from pathlib import Path

from tensorboard.backend.event_processing.event_accumulator import EventAccumulator

tensorboard_dir = Path("output/tensorboard/roll-quick-start-npu")
event_files = sorted(tensorboard_dir.glob("*/events.out.tfevents.*"))
assert event_files, f"no tensorboard event file under {tensorboard_dir}"
metrics = EventAccumulator(str(event_files[-1]))
metrics.Reload()
print("training steps:", len(metrics.Scalars("time/step_total")))
print("samples:", int(metrics.Scalars("system/samples")[-1].value))
print("FrozenLake mean score:", metrics.Scalars("critic/score/mean")[-1].value)
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
