# Quick reference

- The official LM Evaluation Harness Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# LM Evaluation Harness | openEuler

Current LM Evaluation Harness docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[LM Evaluation Harness](https://github.com/EleutherAI/lm-evaluation-harness) (lm-eval) is EleutherAI's unified framework for evaluating large language models. It provides hundreds of standard benchmarks (ARC, HellaSwag, MMLU, GSM8K, Winogrande, ...), a `lm_eval` CLI and a Python API, with pluggable model backends such as HuggingFace `transformers` and vLLM.

This image ships lm-eval with [torch_npu](https://atomgit.com/ascend/pytorch) so that evaluations run seamlessly on the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/lm-evaluation-harness/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the lm-eval documentation at [lm-evaluation-harness.readthedocs.io](https://lm-evaluation-harness.readthedocs.io/).

# Supported tags and respective Dockerfile links

The tag of each LM Evaluation Harness docker image consists of the LM Evaluation Harness version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|
|[0.4.13-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/lm-evaluation-harness/0.4.13-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| LM Evaluation Harness 0.4.13 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the lm-evaluation-harness image
export IMAGE=openeuler/lm-evaluation-harness:0.4.13-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-lm-evaluation-harness \
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

## Quick start 3: run a benchmark with the HuggingFace backend on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
```

Evaluate `Qwen/Qwen2.5-0.5B-Instruct` on the official `arc_easy` task (10 samples for a quick smoke test):

```bash
lm_eval run --model hf \
    --model_args pretrained=Qwen/Qwen2.5-0.5B-Instruct \
    --device npu:0 \
    --batch_size 8 \
    --limit 10 \
    --tasks arc_easy \
    --output_path output/lm_eval_out
```

The accuracy is printed at the end of the run and written to `output/lm_eval_out`. Other tasks, such as `winogrande`, work the same way (`--num_fewshot 5` enables few-shot evaluation).

For faster model download in China, use the ModelScope or hf-mirror channel:

```bash
export HF_ENDPOINT=https://hf-mirror.com
# or
pip install modelscope
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
