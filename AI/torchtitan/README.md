# Quick reference

- The official Torchtitan Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# Torchtitan | openEuler

Current Torchtitan docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[Torchtitan](https://github.com/pytorch/torchtitan) is a PyTorch native, proof-of-concept architecture for large-scale LLM training and inference. It provides composable parallelism (FSDP, tensor and pipeline parallelism), async distributed training via torch.compile and a config-driven `train` entrypoint.

This image ships Torchtitan with [torch_npu](https://atomgit.com/ascend/pytorch) and the matching `triton-ascend` backend so that training runs seamlessly on the Ascend NPU. The software stack is validated on Ascend 910B4 cards with CANN 9.2.0, `torch==2.14.0` and `torch_npu==2.14.0` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/torchtitan/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the Torchtitan documentation at [pytorch.org/torchtitan](https://pytorch.org/torchtitan/).

# Supported tags and respective Dockerfile links

The tag of each Torchtitan docker image consists of the Torchtitan version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.4.0-torch_npu2.14.0-cann9.2.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/torchtitan/0.4.0-torch_npu2.14.0-cann9.2.0-python3.12/24.03-lts-sp4/Dockerfile)| Torchtitan 0.4.0 (torch_npu 2.14.0, CANN 9.2.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the torchtitan image
export IMAGE=openeuler/torchtitan:0.4.0-torch_npu2.14.0-cann9.2.0-python3.12-oe2403sp4
docker run --rm \
--name torchtitan \
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

## Quick start 3: training on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
python3 -c "import torchtitan; print('torchtitan', torchtitan.__version__)"
python3 -c "from importlib.metadata import version; print('triton-ascend', version('triton-ascend'))"
```

The upstream default llama3 configuration uses flex attention and a complex64 RoPE cache, which are not available on the NPU. Following the Ascend quick start, fetch the NPU compatibility override module from the quick start guard repository and register it via torchtitan's official `--override.imports` mechanism (no upstream source files are modified):

```bash
mkdir -p "$HOME/tt-npu-overrides"
BASE="https://api.github.com/repos/cosdt-ci-test/workflows/contents/projects/torchtitan/example"
for f in npu_compat.py npu_compat_deepseek.py check_npu_overrides.py; do
  curl -fsSL -H "Accept: application/vnd.github.raw" "$BASE/$f?ref=main" -o "$HOME/tt-npu-overrides/$f"
done
python "$HOME/tt-npu-overrides/check_npu_overrides.py"
```

`npu override equivalence: rope OK, mask OK, rope selection OK` confirms the replaced components are numerically equivalent to the upstream ones. Then run 2 training steps of the upstream `llama3_debugmodel` (~6M parameters, fits a single card):

```bash
PYTHONPATH="$HOME/tt-npu-overrides" \
ASCEND_RT_VISIBLE_DEVICES=0 \
TORCHINDUCTOR_COMPILE_THREADS=1 \
torchrun --nproc_per_node=1 \
    --rdzv_backend c10d \
    --rdzv_endpoint="localhost:0" \
    -m torchtitan.train \
    --module llama3 \
    --config llama3_debugmodel \
    --override.imports npu_compat.npu_attention \
    --comm.mode default \
    --training.steps 2 \
    --training.local-batch-size 1 \
    --training.seq-len 256 \
    --metrics.log-freq 1 \
    --metrics.disable-color-printing \
    --dump-folder /tmp/torchtitan-quickstart
```

The log prints the 6 applied overrides and ends with `Training completed`. For 2-card FSDP training run the same command with `--nproc_per_node=2`, `--training.dtype bfloat16` and `HCCL_NPU_SOCKET_PORT_RANGE=60000-60200`.

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
