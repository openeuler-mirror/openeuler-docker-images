# Quick reference

- The official Speculators Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# Speculators | openEuler

Current Speculators docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[Speculators](https://github.com/vllm-project/speculators) is an open-source framework for training and deploying speculative decoding draft models. It supports draft algorithms such as DFlash, EAGLE, MTP and PEAGLE, converts existing draft checkpoints, extracts training data from a verifier, trains the draft with `speculators.train`, and mounts the result directly into vLLM via `--speculative-config` to accelerate inference.

This image ships Speculators with the [vLLM-Ascend](https://github.com/vllm-project/vllm-ascend) stack (`vllm==0.23.0`, `vllm-ascend==0.23.0`) on top of [torch_npu](https://atomgit.com/ascend/pytorch), including the in-tree `hs_connectors` package required by `speculators.train`, so that the convert / train / serve pipeline runs seamlessly on the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.10.0`, `torch_npu==2.10.0.post4`, `vllm==0.23.0` and `vllm-ascend==0.23.0` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/speculators/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the Speculators documentation at [github.com/vllm-project/speculators](https://github.com/vllm-project/speculators).

# Supported tags and respective Dockerfile links

The tag of each Speculators docker image consists of the Speculators version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.9.0-torch_npu2.10.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/speculators/0.9.0-torch_npu2.10.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| Speculators 0.9.0 (vLLM 0.23.0, vLLM-Ascend 0.23.0, torch_npu 2.10.0.post4, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the speculators image
export IMAGE=openeuler/speculators:0.9.0-torch_npu2.10.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-speculators \
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

## Quick start 3: verify the speculators stack on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available())"
python3 -c "import importlib.metadata as m; print('speculators', m.version('speculators')); print('vllm', m.version('vllm')); print('vllm-ascend', m.version('vllm-ascend'))"
```

Verify the programmatic entry points can be imported and instantiated on the NPU environment:

```python
from speculators import VerifierConfig
from speculators.proposals.greedy import GreedyTokenProposalConfig

verifier = VerifierConfig(
    name_or_path="Qwen/Qwen3-8B",
    architectures=["Qwen3ForCausalLM"],
)
proposal = GreedyTokenProposalConfig(
    proposal_type="greedy",
    speculative_tokens=5,
    verifier_accept_k=1,
    accept_tolerance=0.0,
)
print("verifier:", verifier.name_or_path)
print("verifier architectures:", verifier.architectures)
print("proposal type:", proposal.proposal_type)
print("proposal speculative_tokens:", proposal.speculative_tokens)
```

The full end-to-end pipeline validated by the quick start guard converts a DFlash draft model with `speculators convert`, prepares and extracts training data, trains the draft with `torchrun -m speculators.train ... --speculator-type dflash --draft-attn-impl sdpa`, and finally serves it with the trained draft mounted for speculative decoding:

```bash
vllm serve Qwen/Qwen3-8B \
  --host 127.0.0.1 --port 8000 \
  --served-model-name Qwen/Qwen3-8B \
  --gpu-memory-utilization 0.85 \
  --enforce-eager \
  --speculative-config '{"method":"dflash","model":"/root/dflash-trained","num_speculative_tokens":5}'
```

For faster model download in China, use the ModelScope or hf-mirror channel:

```bash
export HF_ENDPOINT=https://hf-mirror.com
# or
pip install modelscope
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
