# Quick reference

- The official KTransformers Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# KTransformers | openEuler

Current KTransformers docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[KTransformers](https://github.com/kvcache-ai/ktransformers) is a flexible framework for experiencing cutting-edge LLM inference and fine-tuning optimizations, focused on heterogeneous computing for large MoE models.

This image prepares the Ascend environment for KTransformers on top of [torch_npu](https://atomgit.com/ascend/pytorch) and CANN 9.1.0: it ships the v0.7.2 sources (the archived framework tree used by the upstream Ascend tutorials), the aarch64 build tweaks and all Python dependencies. The C++ extension is then built inside the container on the NPU machine, exactly as the [upstream Ascend tutorial](https://github.com/kvcache-ai/ktransformers/blob/main/doc/zh/DeepseekR1_V3_tutorial_zh_for_Ascend_NPU.md) prescribes, because the build probes the NPU. The upstream tutorials validate on Atlas 300I A2; the entry point is summarized in the [Ascend quick start guide](https://github.com/cosdt-ci-test/workflows/blob/main/projects/ktransformers/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the KTransformers documentation at [kvcache-ai.github.io/ktransformers](https://kvcache-ai.github.io/ktransformers/).

# Supported tags and respective Dockerfile links

The tag of each KTransformers docker image consists of the KTransformers version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.7.2-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/ktransformers/0.7.2-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| KTransformers 0.7.2 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the ktransformers image
export IMAGE=openeuler/ktransformers:0.7.2-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-ktransformers \
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

## Quick start 3: build and serve on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
```

Build the framework inside the container (the build probes the NPU, so it runs on the target machine, following the upstream Ascend tutorial):

```bash
source /usr/local/Ascend/ascend-toolkit/set_env.sh
cd /opt/ktransformers/archive
USE_BALANCE_SERVE=1 USE_NUMA=1 bash ./install.sh
```

Then follow the upstream Ascend tutorials to prepare the merged weights and launch the service (DeepSeek-R1/V3 or Qwen3-MoE):

```bash
source /usr/local/Ascend/ascend-toolkit/set_env.sh
source /usr/local/Ascend/nnal/atb/set_env.sh
python ktransformers/server/main.py \
    --port 10002 \
    --model_path <your model path> \
    --gguf_path <your model path> \
    --model_name DeepSeekV3ForCausalLM \
    --cpu_infer 100 \
    --optimize_config_path ./ktransformers/optimize/optimize_rules/npu/DeepSeek-V3-Chat-300IA2-npu-serve.yaml \
    --max_new_tokens 1024 \
    --cache_lens 20480 \
    --max_batch_size 4 \
    --use_cuda_graph \
    --tp 1 \
    --backend_type balance_serve
```

For faster model download in China, use the ModelScope channel (the tutorials download weights from ModelScope):

```bash
pip install modelscope
export HF_ENDPOINT=https://hf-mirror.com
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
