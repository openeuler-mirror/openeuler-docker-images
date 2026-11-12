# Quick reference

- The official TGI Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# TGI | openEuler

Current TGI docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[Text Generation Inference (TGI)](https://github.com/VenusTZZ/text-generation-inference) is a toolkit for deploying and serving large language models: a Rust launcher/router drives a Python server that supports dynamic batching, tensor parallelism and OpenAI-compatible APIs.

The official TGI releases do not include Ascend NPU support yet. This image builds the Ascend-adapted fork ([VenusTZZ/text-generation-inference](https://github.com/VenusTZZ/text-generation-inference), release `v3.3.7-npu` from the `feat/ascend-npu` branch) from source: Rust launcher and router plus the Python server, on top of [torch_npu](https://atomgit.com/ascend/pytorch) and CANN 9.1.0. The software stack is validated on Ascend 910B4 cards with `torch==2.9.0` and the `torch_npu` 2.9.0 series, single-card and dual-card HCCL tensor parallel (`--num-shard 2`), following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/tgi/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the TGI documentation at [github.com/huggingface/text-generation-inference](https://github.com/huggingface/text-generation-inference).

# Supported tags and respective Dockerfile links

The tag of each TGI docker image consists of the TGI version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[3.3.7-npu-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/tgi/3.3.7-npu-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| TGI 3.3.7-npu (Ascend fork, torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the tgi image
export IMAGE=openeuler/tgi:3.3.7-npu-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-tgi \
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

## Quick start 3: serve on Ascend NPU

Download a model with ModelScope (the quick start uses Qwen3-0.6B):

```bash
python3 -c "from modelscope import snapshot_download; print(snapshot_download('Qwen/Qwen3-0.6B'))"
```

Start TGI on a single card (the launcher, router and server are installed by the image):

```bash
source /usr/local/Ascend/ascend-toolkit/set_env.sh
export ASCEND_VISIBLE_DEVICES=0
export PYTORCH_NPU_ALLOC_CONF=max_split_size_mb:256
text-generation-launcher \
  --model-id "$(python3 -c "from modelscope import snapshot_download; print(snapshot_download('Qwen/Qwen3-0.6B'))")" \
  --num-shard 1 --port 8080 \
  --max-total-tokens 128 --max-input-tokens 100
```

Once `/info` answers, send one generation request:

```bash
curl -4fs http://127.0.0.1:8080/generate \
  -H 'Content-Type: application/json' \
  -d '{"inputs":"What is 1+1? Answer:","parameters":{"max_new_tokens":16,"do_sample":false}}'
```

The service is working when the response contains a non-empty `generated_text`. With two cards, `--num-shard 2` and `ASCEND_VISIBLE_DEVICES=0,1` run HCCL tensor parallel; under greedy decoding the reply must match the single-card baseline.

For faster model download in China, use the ModelScope channel (as above) or the hf-mirror channel:

```bash
export HF_ENDPOINT=https://hf-mirror.com
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
