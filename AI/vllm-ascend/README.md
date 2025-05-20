# Quick reference

- The offical vLLM Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# vLLM Ascend | openEuler

Current vLLM Ascend docker images are built on the [openEuler](https://repo.openeuler.org/)⁠. This repository is free to use and exempted from per-user rate limits.

vLLM Ascend (vllm-ascend) is a community maintained hardware plugin for running vLLM seamlessly on the Ascend NPU.

It is the recommended approach for supporting the Ascend backend within the vLLM community. It adheres to the principles outlined in the [[RFC]: Hardware pluggable](https://github.com/vllm-project/vllm/issues/11162), providing a hardware-pluggable interface that decouples the integration of the Ascend NPU with vLLM.

By using vLLM Ascend plugin, popular open-source models, including Transformer-like, Mixture-of-Expert, Embedding, Multi-modal LLMs can run seamlessly on the Ascend NPU.

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the vLLM Ascend technical documentation at [vllm-ascend.readthedocs.io](https://vllm-ascend.readthedocs.io/en/latest/)

# Supported tags and respective Dockerfile links

The tag of each vLLM Ascend docker image is consist of the version of vLLM Ascend and the version of basic image. The details are as follows

| Tags | Currently |  Architectures|
|--|--|--|
|[0.7.3rc2-torch_npu2.5.1-cann8.0.0-python3.10-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-ascend/0.7.3rc2-torch_npu2.5.1-cann8.0.0-python3.10/22.03-lts/Dockerfile)| vLLM Ascend 0.7.3rc2 on openEuler 22.03-LTS | amd64, arm64 |

|[0.7.3-torch_npu2.5.1-cann8.1.rc1-python3.10-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-ascend/0.7.3-torch_npu2.5.1-cann8.1.rc1-python3.10/22.03-lts/Dockerfile)| vLLM Ascend 0.7.3 on openEuler 22.03-LTS | amd64, arm64 |

|[0.8.5rc1-torch_npu2.5.1-cann8.1.rc1-python3.10-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-ascend/0.8.5rc1-torch_npu2.5.1-cann8.1.rc1-python3.10/22.03-lts/Dockerfile)| vLLM Ascend 0.8.5rc1 on openEuler 22.03-LTS | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the vllm-ascend image
export IMAGE=quay.io/ascend/vllm-ascend:v0.8.4rc1-openeuler
docker run --rm \
--name vllm-ascend \
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
-p 8000:8000 \
-it $IMAGE bash
```

## Quick start 3: offline inference

You can use Modelscope mirror to speed up download:

```bash
export VLLM_USE_MODELSCOPE=true
```

With vLLM installed, you can start generating texts for list of input prompts (i.e. offline batch inferencing).

Try to run below Python script directly or use `python3` shell to generate texts:

```python
from vllm import LLM, SamplingParams

prompts = [
    "Hello, my name is",
    "The future of AI is",
]
sampling_params = SamplingParams(temperature=0.8, top_p=0.95)
# The first run will take about 3-5 mins (10 MB/s) to download models
llm = LLM(model="Qwen/Qwen2.5-0.5B-Instruct")

outputs = llm.generate(prompts, sampling_params)

for output in outputs:
    prompt = output.prompt
    generated_text = output.outputs[0].text
    print(f"Prompt: {prompt!r}, Generated text: {generated_text!r}")
```


# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)⁠.