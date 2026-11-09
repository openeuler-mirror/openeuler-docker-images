# Quick reference

- The official verl Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# verl | openEuler

Current verl docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[verl](https://github.com/verl-project/verl) (Volcano Engine Reinforcement Learning for LLM) is a distributed RLHF/RL training framework. It supports SFT, PPO/GRPO and agentic RL pipelines over pluggable training backends (FSDP2, Megatron) and rollout engines (vLLM, SGLang), orchestrated by the hybrid-controller architecture on Ray.

This image ships verl with [torch_npu](https://atomgit.com/ascend/pytorch), the vLLM-Ascend rollout stack and the Megatron/MindSpeed training stack, so RL post-training runs seamlessly on the Ascend NPU. The software stack follows the upstream `Dockerfile.ascend_9.1.0_a2` of the verl repository: vLLM 0.30.0, vLLM-Ascend 0.30.0, Megatron-LM core_v0.18.0, Megatron-Bridge 0.5.0, MindSpeed core_r0.18.0, `torch==2.10.0`, `torch_npu==2.10.0.post7`, `transformers==5.14.1` and `triton-ascend==3.6.0.post2` with CANN 9.1.0 on Python 3.12. See the [Ascend quick start guide](https://github.com/verl-project/verl/blob/main/docs/ascend_tutorial/en/get_start/quick_start.rst) for how the stack is validated.

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the verl documentation at [verl.readthedocs.io](https://verl.readthedocs.io/).

# Supported tags and respective Dockerfile links

The tag of each verl docker image consists of the verl version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.10.0.dev-torch_npu2.10.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/verl/0.10.0.dev-torch_npu2.10.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| verl 0.10.0.dev (vLLM-Ascend 0.30.0, torch_npu 2.10.0.post7, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the verl image
export IMAGE=openeuler/verl:0.10.0.dev-torch_npu2.10.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-verl \
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

## Quick start 3: GRPO training on Ascend NPU

Validate the environment inside the container:

```bash
source /usr/local/Ascend/ascend-toolkit/set_env.sh && \
source /usr/local/Ascend/nnal/atb/set_env.sh
python3 -c "import torch, torch_npu, vllm, vllm_ascend, verl; print('torch_npu', torch_npu.__version__); print('vllm', vllm.__version__); print('verl', verl.__version__); print('is_available:', torch.npu.is_available())"
```

Then run the GSM8K GRPO quick start with the Qwen3-0.6B model, following the [Ascend quick start guide](https://github.com/verl-project/verl/blob/main/docs/ascend_tutorial/en/get_start/quick_start.rst):

```bash
# 1. Prepare the Qwen3-0.6B weights (downloaded from Hugging Face or ModelScope)
#    and place them at ~/models/Qwen/Qwen3-0.6B

# 2. Preprocess the GSM8K dataset
cd /verl
python3 examples/data_preprocess/gsm8k.py --local_dataset_path /download/path/hf_data/gsm8k/

# 3. Run the vLLM + FSDP2 quick start script (vLLM-Ascend rollout built into this image)
bash tests/special_npu/quick_start/run_qwen3_0_6b_fsdp2_vllm_ascend.sh
```

The script initializes the actor, rollout and reference workers, generates responses with vLLM-Ascend, and completes the first GRPO training step. Other training and inference backend combinations (vLLM + Megatron, SGLang + FSDP2, SGLang + Megatron) are also available under `tests/special_npu/quick_start/`; note that SGLang is not installed in this vLLM-flavored image.

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
