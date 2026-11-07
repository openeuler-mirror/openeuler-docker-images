# Quick reference

- The official ms-swift Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# ms-swift | openEuler

Current ms-swift docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[ms-swift](https://github.com/modelscope/ms-swift) is the official ModelScope framework for the training, inference, deployment and evaluation of large language and multimodal models. It supports 300+ models with SFT, LoRA, DPO, GRPO and other fine-tuning algorithms, and applies NPU model patches automatically on Ascend.

This image ships ms-swift with [torch_npu](https://atomgit.com/ascend/pytorch) so that fine-tuning and inference run seamlessly on the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/ms-swift/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the ms-swift documentation at [modelscope.github.io/ms-swift](https://modelscope.github.io/ms-swift/).

# Supported tags and respective Dockerfile links

The tag of each ms-swift docker image consists of the ms-swift version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[4.6.0-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/ms-swift/4.6.0-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| ms-swift 4.6.0 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the ms-swift image
export IMAGE=openeuler/ms-swift:4.6.0-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name ms-swift \
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

## Quick start 3: fine-tuning on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
python3 -c "import swift; print('ms-swift', swift.__version__)"
```

Fine-tune `Qwen/Qwen3-4B-Instruct-2507` with LoRA on a single card (about 2 minutes for 5 steps; models and datasets are downloaded from ModelScope by default):

```bash
ASCEND_RT_VISIBLE_DEVICES=0 swift sft \
    --model Qwen/Qwen3-4B-Instruct-2507 \
    --tuner_type lora \
    --dataset 'AI-ModelScope/alpaca-gpt4-data-zh#500' \
              'AI-ModelScope/alpaca-gpt4-data-en#500' \
              'swift/self-cognition#500' \
    --torch_dtype bfloat16 \
    --per_device_train_batch_size 1 \
    --per_device_eval_batch_size 1 \
    --learning_rate 1e-4 \
    --lora_rank 8 \
    --lora_alpha 32 \
    --target_modules all-linear \
    --gradient_accumulation_steps 16 \
    --max_length 2048 \
    --output_dir output \
    --warmup_ratio 0.05 \
    --dataloader_num_workers 4 \
    --model_author swift \
    --model_name swift-robot \
    --max_steps 5 \
    --save_strategy steps \
    --save_steps 5 \
    --logging_steps 1 \
    --eval_strategy no \
    --report_to none
```

After training, chat with the fine-tuned checkpoint (`<ckpt>` is the `checkpoint-*` folder printed under `output/`):

```bash
ASCEND_RT_VISIBLE_DEVICES=0 \
swift infer \
    --adapters <ckpt> \
    --stream true \
    --temperature 0 \
    --max_new_tokens 2048
```

To use a Hugging Face model id instead of ModelScope, add `--use_hf true`. For the full NPU deployment guide (vLLM-Ascend, DeepSpeed, DDP) see the [NPU best practices](https://github.com/modelscope/ms-swift/blob/main/docs/source/BestPractices/NPU-support.md).

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
