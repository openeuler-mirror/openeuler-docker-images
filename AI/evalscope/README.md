# Quick reference

- The official EvalScope Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# EvalScope | openEuler

Current EvalScope docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[EvalScope](https://github.com/modelscope/evalscope) is a lightweight large model evaluation framework from the ModelScope team. It wraps multiple evaluation backends for LLM/VLM/RAG/AIGC workloads and ships a visualization dashboard. Its Native backend is built on transformers + accelerate and passes `device_map="npu"` to `from_pretrained` on Ascend, so models load directly onto the NPU.

This image ships EvalScope with [torch_npu](https://atomgit.com/ascend/pytorch) so that evaluations run on the Ascend NPU via the Native backend. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/evalscope/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the EvalScope documentation at [evalscope.readthedocs.io](https://evalscope.readthedocs.io/zh-cn/latest/).

# Supported tags and respective Dockerfile links

The tag of each EvalScope docker image consists of the EvalScope version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[1.14.1-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/evalscope/1.14.1-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| EvalScope 1.14.1 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the evalscope image
export IMAGE=openeuler/evalscope:1.14.1-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name evalscope \
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

## Quick start 3: evaluate a model on Ascend NPU

Load the CANN environment and validate the stack inside the container:

```bash
source /usr/local/Ascend/ascend-toolkit/set_env.sh
python3 -c "import evalscope, torch, torch_npu; print('evalscope', evalscope.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
```

Download the model from ModelScope (about 1 GB on the first run, cached under `~/.cache/modelscope` afterwards):

```bash
python3 -c "from modelscope import snapshot_download; print(snapshot_download('Qwen/Qwen2.5-0.5B-Instruct'))"
```

Confirm the model can be loaded onto the NPU (this is the same loading path used by the EvalScope Native backend):

```python
import torch
import torch_npu
from transformers import AutoModelForCausalLM

m = AutoModelForCausalLM.from_pretrained('<MODEL_PATH>', torch_dtype='auto', device_map='npu')
dev = str(next(m.parameters()).device)
print('evalscope_npu_device', dev)
assert dev.startswith('npu'), dev
```

Run a small evaluation on the `gsm8k` and `arc` datasets with the Native backend (`--limit 5` takes only a few samples for a quick check, not real leaderboard numbers):

```bash
evalscope eval \
  --model <MODEL_PATH> \
  --datasets gsm8k arc \
  --limit 5 \
  --no-timestamp \
  --model-args '{"device_map": "npu"}' \
  --work-dir outputs/evalscope_npu_qs
```

The reports are written to `outputs/evalscope_npu_qs/reports/<model>/` as JSON files; every `score` should fall into [0, 1]. To pin a specific card, use `ASCEND_RT_VISIBLE_DEVICES` (for example `0` for the first card). More datasets, batch evaluation and the visualization dashboard are covered in the official documentation.

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
