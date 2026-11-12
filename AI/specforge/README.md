# Quick reference

- The official SpecForge Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# SpecForge | openEuler

Current SpecForge docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[SpecForge](https://github.com/sgl-project/SpecForge) is a speculative decoding training framework from the SGLang project. It trains draft models from typed run configs (`specforge train`), exports runtime checkpoints (`specforge export`) and benchmarks running SGLang servers (`specforge benchmark`). The online (disaggregated) mode captures hidden states from a patched SGLang capture server and transfers them to the trainer via mooncake.

This image ships SpecForge installed from source with [torch_npu](https://atomgit.com/ascend/pytorch) and the mooncake NPU transfer engine; the example configs and the sglang spec-capture patch set are kept under `/opt/SpecForge`. The Ascend software stack is validated on Ascend 910B cards (4 cards for the online smoke) with CANN, `torch==2.10.0` and `torch_npu==2.10.0.post6` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/specforge/docs/Quick-start-Ascend.md). Note that the quick start guard runs against an SGLang server image (sglang 0.5.18 with CANN); provision a compatible SGLang server before starting online training with this image.

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the SGLang project at [sgl-project.ai](https://sgl-project.ai/).

# Supported tags and respective Dockerfile links

The tag of each SpecForge docker image consists of the SpecForge version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[b520d2b-torch_npu2.10.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/specforge/b520d2b-torch_npu2.10.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| SpecForge b520d2b (torch_npu 2.10.0.post6, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the specforge image
export IMAGE=openeuler/specforge:b520d2b-torch_npu2.10.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name specforge \
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

## Quick start 3: speculative decoding training on Ascend NPU

Load the CANN environment and validate the stack inside the container:

```bash
source /usr/local/Ascend/ascend-toolkit/set_env.sh
python3 -c "
import specforge, torch, torch_npu
print('specforge', getattr(specforge, '__version__', 'unknown'))
print('torch', torch.__version__)
print('torch.npu.is_available', torch.npu.is_available())
"
```

Check the CLI (three subcommands: train / export / benchmark):

```bash
specforge --help
specforge train --help
```

For an end-to-end online training run, follow the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/specforge/docs/Quick-start-Ascend.md): start `mooncake_master`, launch a patched SGLang capture server (spec-capture, dflash method) with a model such as `Qwen/Qwen3.5-4B` from ModelScope, and run a minimal training step with the upstream recipe (card 0 for the capture server, card 1 for the trainer, cards 2/3 reserved for HCCL communication buffers):

```bash
modelscope download --model Qwen/Qwen3.5-4B
specforge train -c examples/configs/online/disaggregated/external/qwen3.5-4b-dflash-online-npu.yaml \
    training.max_steps=1 \
    training.batch_size=1 \
    training.accumulation_steps=1 \
    data.max_length=512 \
    data.train_data_path=<SHAREGPT_JSONL> \
    training.num_anchors=32 \
    training.save_interval=0 \
    training.log_interval=1 \
    tracking.report_to=none \
    deployment.trainer.nproc_per_node=1 \
    deployment.disaggregated.receive_buffers=pageable \
    model.target_model_path=<MODEL_PATH> \
    model.embedding_key="model.language_model.embed_tokens.weight"
```

Before starting, apply the spec-capture patches to the SGLang server with `scripts/apply_sglang_spec_capture_patch.sh` from the SpecForge checkout; the training log is expected to show step/loss lines.

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
