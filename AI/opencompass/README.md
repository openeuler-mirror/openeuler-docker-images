# Quick reference

- The official OpenCompass Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# OpenCompass | openEuler

Current OpenCompass docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[OpenCompass](https://github.com/open-compass/opencompass) is an open source large language model evaluation framework. It provides unified abstractions for models, datasets and summarizers, plus a rich collection of benchmark configurations, so LLMs can be evaluated with a single config file. The native Hugging Face wrapper selects `device_map="npu"` automatically when `mmengine.device.is_npu_available()` is true.

This image ships OpenCompass with [torch_npu](https://atomgit.com/ascend/pytorch) so that evaluations run on the Ascend NPU via the native `HuggingFacewithChatTemplate` path. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/opencompass/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the OpenCompass documentation at [opencompass.readthedocs.io](https://opencompass.readthedocs.io/).

# Supported tags and respective Dockerfile links

The tag of each OpenCompass docker image consists of the OpenCompass version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.5.5-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/opencompass/0.5.5-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| OpenCompass 0.5.5 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the opencompass image
export IMAGE=openeuler/opencompass:0.5.5-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name opencompass \
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
python3 -c "import torch, torch_npu, opencompass; print('opencompass', opencompass.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
```

Download the model from ModelScope (about 1 GB on the first run, cached under `~/.cache/modelscope` afterwards):

```bash
python3 -c "from modelscope import snapshot_download; print(snapshot_download('Qwen/Qwen2-0.5B-Instruct'))"
```

In a working directory, create `npu_chat.py`, a small model subclass that prints the device before generation:

```python
from opencompass.models.huggingface_above_v4_33 import HuggingFacewithChatTemplate
from opencompass.registry import MODELS


@MODELS.register_module()
class HuggingFaceNPUChat(HuggingFacewithChatTemplate):
    def generate(self, inputs, max_out_len, **kwargs):
        print('\nopencompass_model_device', next(self.model.parameters()).device, flush=True)
        return super().generate(inputs, max_out_len, **kwargs)
```

Create `eval_qwen2_gsm8k.py` and replace `<MODEL_PATH>` with the path printed above:

```python
from mmengine.config import read_base
from npu_chat import HuggingFaceNPUChat

with read_base():
    from opencompass.configs.datasets.demo.demo_gsm8k_chat_gen import gsm8k_datasets

gsm8k_datasets[0]['infer_cfg']['inferencer']['max_out_len'] = 32

datasets = gsm8k_datasets
models = [
    dict(
        type=HuggingFaceNPUChat,
        abbr='qwen2-0.5b-instruct',
        path=r'<MODEL_PATH>',
        max_out_len=32,
        batch_size=4,
        model_kwargs=dict(torch_dtype='bfloat16'),
        run_cfg=dict(num_gpus=1),
    )
]
```

Run the evaluation on the GSM8K demo dataset (64 samples, `--debug` runs the scheduler in the current process):

```bash
export PYTHONPATH="$PWD${PYTHONPATH:+:$PYTHONPATH}"
export DATASET_SOURCE=ModelScope
opencompass eval_qwen2_gsm8k.py --debug -w outputs/oc_npu_qs 2>&1
cat outputs/oc_npu_qs/*/summary/summary_*.txt
```

The log must contain `opencompass_model_device npu:0` (the model is loaded on the NPU) and the summary reports `demo_gsm8k` accuracy. For faster model download in China, use the ModelScope channel as shown above; do not switch the dataset source back to a direct Hugging Face connection.

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
