# Quick reference

- The official whisper.cpp Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# whisper.cpp | openEuler

Current whisper.cpp docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[whisper.cpp](https://github.com/ggml-org/whisper.cpp) is a plain C/C++ implementation of OpenAI's Whisper automatic speech recognition model, offering high-performance speech-to-text inference without dependencies.

This image ships whisper.cpp with the [GGML CANN backend](https://github.com/ggml-org/whisper.cpp#ascend-npu-support) so that transcription is offloaded to the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/whisper.cpp/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the whisper.cpp documentation at [github.com/ggml-org/whisper.cpp](https://github.com/ggml-org/whisper.cpp).

# Supported tags and respective Dockerfile links

The tag of each whisper.cpp docker image consists of the whisper.cpp version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[1.9.5-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/whisper.cpp/1.9.5-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| whisper.cpp 1.9.5 (CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the whisper.cpp image
export IMAGE=openeuler/whisper.cpp:1.9.5-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-whisper.cpp \
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

## Quick start 3: transcribe on Ascend NPU

Download a ggml format model (the `tiny.en` English model, about 77 MB, from ModelScope) and verify the file header magic:

```bash
mkdir -p models
curl -fL --retry 3 --retry-delay 5 --connect-timeout 30 \
    -o models/ggml-tiny.en.bin \
    https://www.modelscope.cn/models/cjc1887415157/whisper.cpp/resolve/master/ggml-tiny.en.bin
head -c 4 models/ggml-tiny.en.bin
```

Transcribe the bundled JFK sample (16-bit WAV; `whisper-cli` and the other tools are installed in `/usr/local/bin`, sample audio is kept in `/usr/local/share/whisper.cpp/samples`):

```bash
ASCEND_RT_VISIBLE_DEVICES=0 whisper-cli \
    -m models/ggml-tiny.en.bin \
    -f /usr/local/share/whisper.cpp/samples/jfk.wav \
    -t 4 --device 0
```

The transcription succeeds when the process exits with code 0, the transcript of the JFK speech is printed, and the log contains a `whisper_backend_init_gpu: using CANN0 backend` line, which proves that the model was initialized on the NPU. Without it the process may still return 0 after silently falling back to the CPU.

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
