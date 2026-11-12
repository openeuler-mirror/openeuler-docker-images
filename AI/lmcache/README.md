# Quick reference

- The official LMCache Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# LMCache | openEuler

Current LMCache docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[LMCache](https://github.com/LMCache/LMCache) is a KV-cache engine for LLM serving. It caches, reuses and shares KV caches across requests and serving instances (prefix caching, cross-instance and cross-model sharing), reducing time-to-first-token and raising throughput in long-context scenarios. It integrates with serving frameworks such as vLLM and SGLang.

This image ships LMCache built from source with the Ascend build profile on top of [torch_npu](https://atomgit.com/ascend/pytorch), with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12. The Ascend NPU KV-cache kernels live in the community plugin [LMCache-Ascend](https://github.com/LMCache/LMCache-Ascend): per its compatibility matrix, pair this image with LMCache-Ascend `v0.5.6` and vLLM-Ascend, and follow the plugin's [Getting Started](https://github.com/LMCache/LMCache-Ascend#getting-started) guide.

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the LMCache documentation at [docs.lmcache.ai](https://docs.lmcache.ai/).

# Supported tags and respective Dockerfile links

The tag of each LMCache docker image consists of the LMCache version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|
|[0.5.6-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/lmcache/0.5.6-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| LMCache 0.5.6 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the lmcache image
export IMAGE=openeuler/lmcache:0.5.6-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-lmcache \
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

## Quick start 3: validate LMCache inside the container

Validate the NPU environment and the LMCache installation:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
python3 -c "import lmcache; print('lmcache', lmcache.__version__)"
```

Start the LMCache server the way the Ascend plugin consumes it:

```bash
lmcache server \
    --chunk-size 128 \
    --l1-size-gb 50 \
    --eviction-policy LRU
```

Wait for `LMCache INFO: LMCache zmq cache server is running on localhost:5555`, then start vLLM-Ascend with the `LMCacheMPConnector` KV transfer connector as described in the [LMCache-Ascend Getting Started](https://github.com/LMCache/LMCache-Ascend#getting-started) guide.

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
