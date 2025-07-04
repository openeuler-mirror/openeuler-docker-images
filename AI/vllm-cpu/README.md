# Quick reference

- The offical vLLM Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# vLLM | openEuler

Current vLLM docker images are built on the [openEuler](https://repo.openeuler.org/)⁠. This repository is free to use and exempted from per-user rate limits.

vLLM is a fast and easy-to-use library for LLM inference and serving.

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

The tag of each vLLM docker image is consist of the version of vLLM and the version of basic image. The details are as follows

| Tags | Currently |  Architectures|
|--|--|--|
|[0.6.3-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.6.3/24.03-lts/Dockerfile)| vLLM 0.6.3 on openEuler 24.03-LTS | amd64 |
|[0.8.3-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.8.3/22.03-lts-sp4/Dockerfile)| vLLM 0.8.3 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[0.8.3-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.8.3/24.03-lts/Dockerfile)| vLLM 0.8.3 on openEuler 24.03-LTS | amd64, arm64 |
|[0.8.4-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.8.4/22.03-lts-sp4/Dockerfile)| vLLM 0.8.4 on openEuler 22.03-LTS-SP4 | amd64 |
|[0.8.4-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.8.4/24.03-lts/Dockerfile)| vLLM 0.8.4 on openEuler 24.03-LTS | amd64 |
|[0.8.5-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.8.5/22.03-lts-sp4/Dockerfile)| vLLM 0.8.5 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[0.8.5-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.8.5/24.03-lts/Dockerfile)| vLLM 0.8.5 on openEuler 24.03-LTS | amd64, arm64 |
|[0.9.0-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.9.0/22.03-lts-sp4/Dockerfile)| vLLM 0.9.0 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[0.9.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.9.0/24.03-lts/Dockerfile)| vLLM 0.9.0 on openEuler 24.03-LTS | amd64, arm64 |
|[0.9.1-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.9.1/22.03-lts-sp4/Dockerfile)| vLLM 0.9.1 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[0.9.1-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/vllm-cpu/0.9.1/24.03-lts/Dockerfile)| vLLM 0.9.1 on openEuler 24.03-LTS | amd64, arm64 |


# Usage

## Quick start 1: supported devices

- Intel/AMD x86
- ARM AArch64

## Quick start 2: setup environment using container

```bash
# Update the vllm image
docker run --rm --name vllm -p 8000:8000 -it --entrypoint bash openeuler/vllm-cpu:latest
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
llm = LLM(model="Qwen/Qwen3-8B")

outputs = llm.generate(prompts, sampling_params)

for output in outputs:
    prompt = output.prompt
    generated_text = output.outputs[0].text
    print(f"Prompt: {prompt!r}, Generated text: {generated_text!r}")
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)⁠.
