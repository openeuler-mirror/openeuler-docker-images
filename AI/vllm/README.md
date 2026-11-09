# Quick reference

- The official vLLM CPU and vLLM Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# vLLM | openEuler

Current vLLM docker images are built on the [openEuler](https://repo.openeuler.org/)⁠. This repository is free to use and exempted from per-user rate limits.

vLLM is a fast and easy-to-use library for LLM inference and serving.

vLLM Ascend (vllm-ascend) is a community maintained hardware plugin for running vLLM seamlessly on the Ascend NPU.

Originally developed in the [Sky Computing Lab](https://sky.cs.berkeley.edu/) at UC Berkeley, vLLM has evolved into a community-driven project with contributions from both academia and industry.

vLLM is fast with:

- State-of-the-art serving throughput
- Efficient management of attention key and value memory with [PagedAttention](https://blog.vllm.ai/2023/06/20/vllm.html)
- Continuous batching of incoming requests
- Fast model execution with CUDA/HIP graph
- Quantizations: [GPTQ](https://arxiv.org/abs/2210.17323), [AWQ](https://arxiv.org/abs/2306.00978), INT4, INT8, and FP8.
- Optimized CUDA kernels, including integration with FlashAttention and FlashInfer.
- Speculative decoding
- Chunked prefill

Read more about vLLM at [vLLM paper](https://arxiv.org/abs/2309.06180) (SOSP 2023) and explore the vLLM technical documentation at [docs.vllm.ai](https://docs.vllm.ai/)

# Supported tags and respective Dockerfile links

The tag of each vLLM docker image is consist of the version of vLLM and the version of basic image. For vLLM Ascend images, the tag also contains the versions of torch_npu, CANN and Python. The details are as follows

| Tags | Currently |  Architectures|
|--|--|--|
|[0.30.0-torch_npu2.10.0.post7-cann9.2.1-python3.12-oe2403lts](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.30.0-torch_npu2.10.0.post7-cann9.2.1-python3.12/24.03-lts/Dockerfile) | vLLM Ascend 0.30.0 (torch_npu 2.10.0.post7, CANN 9.2.1, Python 3.12) on openEuler 24.03-LTS | amd64, arm64 |
|[0.23.0-torch_npu2.10.0.post4-cann9.1.0-python3.12-oe2403lts](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.23.0-torch_npu2.10.0.post4-cann9.1.0-python3.12/24.03-lts/Dockerfile) | vLLM Ascend 0.23.0 (torch_npu 2.10.0.post4, CANN 9.1.0, Python 3.12) on openEuler 24.03-LTS | amd64, arm64 |
|[0.29.0-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.29.0/24.03-lts-sp4/Dockerfile) | vllm 0.29.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[0.23.0-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.23.0/24.03-lts-sp4/Dockerfile) | vllm 0.23.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[0.23.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.23.0/24.03-lts-sp3/Dockerfile) | vllm 0.23.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
|[0.20.1-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.20.1/24.03-lts-sp3/Dockerfile) | vllm 0.20.1 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
|[0.18.0-torch_npu2.9.0.post1-cann8.5.1-python3.11-oe2403lts](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.18.0-torch_npu2.9.0.post1-cann8.5.1-python3.11/24.03-lts/Dockerfile) | vLLM Ascend 0.18.0 (torch_npu 2.9.0.post1, CANN 8.5.1, Python 3.11) on openEuler 24.03-LTS | amd64, arm64 |
|[0.18.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.18.0/24.03-lts-sp3/Dockerfile) | vllm 0.18.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
|[0.16.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.16.0/24.03-lts-sp3/Dockerfile) | vllm 0.16.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
|[0.6.3-oe2403lts](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.6.3/24.03-lts/Dockerfile)| vLLM 0.6.3 on openEuler 24.03-LTS | amd64 |
|[0.8.3-oe2203sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.8.3/22.03-lts-sp4/Dockerfile)| vLLM 0.8.3 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[0.8.3-oe2403lts](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.8.3/24.03-lts/Dockerfile)| vLLM 0.8.3 on openEuler 24.03-LTS | amd64, arm64 |
|[0.8.4-oe2203sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.8.4/22.03-lts-sp4/Dockerfile)| vLLM 0.8.4 on openEuler 22.03-LTS-SP4 | amd64 |
|[0.8.4-oe2403lts](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.8.4/24.03-lts/Dockerfile)| vLLM 0.8.4 on openEuler 24.03-LTS | amd64 |
|[0.8.5-oe2203sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.8.5/22.03-lts-sp4/Dockerfile)| vLLM 0.8.5 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[0.8.5-oe2403lts](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.8.5/24.03-lts/Dockerfile)| vLLM 0.8.5 on openEuler 24.03-LTS | amd64, arm64 |
|[0.9.0-oe2203sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.9.0/22.03-lts-sp4/Dockerfile)| vLLM 0.9.0 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[0.9.0-oe2403lts](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.9.0/24.03-lts/Dockerfile)| vLLM 0.9.0 on openEuler 24.03-LTS | amd64, arm64 |
|[0.9.1-oe2203sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.9.1/22.03-lts-sp4/Dockerfile)| vLLM 0.9.1 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[0.9.1-oe2403lts](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.9.1/24.03-lts/Dockerfile)| vLLM 0.9.1 on openEuler 24.03-LTS | amd64, arm64 |
|[0.10.1-oe2203sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.10.1/22.03-lts-sp4/Dockerfile)| vLLM 0.10.1 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[0.10.1-oe2403lts](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.10.1/24.03-lts/Dockerfile)| vLLM 0.10.1 on openEuler 24.03-LTS | amd64, arm64 |
|[0.13.0-torch_npu2.8.0.post2-cann8.5.0-python3.11-oe2403lts](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.13.0-torch_npu2.8.0.post2-cann8.5.0-python3.11/24.03-lts/Dockerfile) | vLLM Ascend 0.13.0 (torch_npu 2.8.0.post2, CANN 8.5.0, Python 3.11) on openEuler 24.03-LTS | amd64, arm64 |
|[0.14.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/vllm/0.14.0/24.03-lts-sp3/Dockerfile) | vllm 0.14.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Intel/AMD x86
- ARM AArch64
- Ascend NPU (Atlas A2 training and inference series, for vLLM Ascend images)

## Quick start 2: setup environment using container

For CPU images:

```bash
# Update the vllm image
docker run --rm --name vllm -p 8000:8000 -it --entrypoint bash openeuler/vllm:latest
```

For vLLM Ascend images:

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the vllm-ascend image
export IMAGE=openeuler/vllm:0.13.0-torch_npu2.8.0.post2-cann8.5.0-python3.11-oe2403lts
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

For more official vLLM Ascend images (including A3, 310P, and 950DT hardware variants) and installation methods, refer to the [vLLM Ascend installation guide](https://docs.vllm.ai/projects/ascend).

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
llm = LLM(model="Qwen/Qwen3-8B")

outputs = llm.generate(prompts, sampling_params)

for output in outputs:
    prompt = output.prompt
    generated_text = output.outputs[0].text
    print(f"Prompt: {prompt!r}, Generated text: {generated_text!r}")
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images)⁠.