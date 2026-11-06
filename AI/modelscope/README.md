# Quick reference

- The official ModelScope Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# ModelScope | openEuler

Current ModelScope docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[ModelScope](https://github.com/modelscope/modelscope) is the open-source framework behind the ModelScope hub. It provides `modelscope download` for pulling models and datasets from the hub, patched `from_pretrained`/`AutoModelForCausalLM` loaders, and a pipeline API covering LLM, CV, audio and multimodal tasks.

This image ships ModelScope with [torch_npu](https://atomgit.com/ascend/pytorch) so that downloaded models can run directly on the Ascend NPU: model weights are fetched through the ModelScope hub and placed on the device with `.to('npu:0')` through `torch_npu`. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/modelscope/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the ModelScope documentation at [modelscope.cn/docs](https://modelscope.cn/docs).

# Supported tags and respective Dockerfile links

The tag of each ModelScope docker image consists of the ModelScope version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[1.40.2-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/modelscope/1.40.2-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| ModelScope 1.40.2 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the modelscope image
export IMAGE=openeuler/modelscope:1.40.2-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name modelscope \
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

## Quick start 3: download a model and generate text on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
python3 -c "import modelscope, transformers; print('modelscope', modelscope.__version__); print('transformers', transformers.__version__)"
```

Download a model from the ModelScope hub (weights are cached in `~/.cache/modelscope`):

```bash
modelscope download --model Qwen/Qwen2.5-0.5B-Instruct
```

Load the model and generate text on the NPU (no Hugging Face token required):

```python
import torch
import torch_npu
from modelscope import AutoModelForCausalLM, AutoTokenizer

model_id = 'Qwen/Qwen2.5-0.5B-Instruct'

model = AutoModelForCausalLM.from_pretrained(model_id, trust_remote_code=True).to('npu:0')
tokenizer = AutoTokenizer.from_pretrained(model_id, trust_remote_code=True)

print('model device:', next(model.parameters()).device)

messages = [
    {'role': 'system', 'content': 'You are a helpful assistant.'},
    {'role': 'user', 'content': '用一句话介绍 ModelScope。'},
]
text = tokenizer.apply_chat_template(messages, tokenize=False, add_generation_prompt=True)
model_inputs = tokenizer([text], return_tensors='pt').to('npu:0')
generated_ids = model.generate(**model_inputs, max_new_tokens=64)
generated_ids = [out[len(inp):] for inp, out in zip(model_inputs.input_ids, generated_ids)]
print('generated:', tokenizer.batch_decode(generated_ids, skip_special_tokens=True)[0])
```

`model device: npu:0` confirms that the weights are placed on the Ascend device. Note that the `pipeline(..., device=...)` API currently accepts only `cpu`/`cuda`/`gpu`, so NPU workloads should load the model explicitly and call `.to('npu:0')` as above.

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
