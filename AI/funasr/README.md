# Quick reference

- The official FunASR Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# FunASR | openEuler

Current FunASR docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[FunASR](https://github.com/modelscope/FunASR) is an open-source speech recognition toolkit from the ModelScope speech team. It provides a fundamental speech recognition model (`paraformer`), a streaming framework, punctuation restoration, speaker verification and the multi-functional `AutoModel` API, plus a `funasr` CLI for transcription with JSON/SRT output.

This image ships FunASR with [torch_npu](https://atomgit.com/ascend/pytorch): `AutoModel` natively accepts `device="npu:0"`, places all sub-models on the Ascend NPU and runs inference through `torch_npu`. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/funasr/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the FunASR documentation at [github.com/modelscope/FunASR](https://github.com/modelscope/FunASR/blob/main/docs/README.md).

# Supported tags and respective Dockerfile links

The tag of each FunASR docker image consists of the FunASR version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[1.4.22-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/funasr/1.4.22-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| FunASR 1.4.22 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the funasr image
export IMAGE=openeuler/funasr:1.4.22-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name funasr \
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

## Quick start 3: speech recognition on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
funasr --version
```

Run the production-grade ASR pipeline (paraformer-zh + FSMN-VAD + punctuation + speaker embeddings) on the NPU; models are downloaded from ModelScope on first use:

```python
import torch, torch_npu
from funasr import AutoModel

model = AutoModel(
    model="paraformer-zh",
    vad_model="fsmn-vad",
    punc_model="ct-punc",
    spk_model="cam++",
    device="npu:0",
    disable_update=True,
)
result = model.generate(
    input="https://isv-data.oss-cn-hangzhou.aliyuncs.com/ics/MaaS/ASR/test_audio/asr_example_zh.wav",
)
r = result[0]
print('device:', next(model.model.parameters()).device)
print('text:', r['text'])
```

`device: npu:0` confirms that the ASR weights are placed on the Ascend device. The `funasr` CLI transcribes with the same models, e.g. `funasr audio.wav --device npu:0 -f json`.

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
