# Quick reference

- The offical SGLang docker images

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# SGLang | openEuler

Current SGLang docker images are built on the [openEuler](https://repo.openeuler.org/)⁠. This repository is free to use and exempted from per-user rate limits.

## About
SGLang is a high-performance serving framework for large language models and vision-language models.
It is designed to deliver low-latency and high-throughput inference across a wide range of setups, from a single GPU to large distributed clusters.
Its core features include:

- **Fast Backend Runtime**: Provides efficient serving with RadixAttention for prefix caching, a zero-overhead CPU scheduler, prefill-decode disaggregation, speculative decoding, continuous batching, paged attention, tensor/pipeline/expert/data parallelism, structured outputs, chunked prefill, quantization (FP4/FP8/INT4/AWQ/GPTQ), and multi-LoRA batching.
- **Extensive Model Support**: Supports a wide range of generative models (Llama, Qwen, DeepSeek, Kimi, GLM, GPT, Gemma, Mistral, etc.), embedding models (e5-mistral, gte, mcdse), and reward models (Skywork), with easy extensibility for integrating new models. Compatible with most Hugging Face models and OpenAI APIs.
- **Extensive Hardware Support**: Runs on NVIDIA GPUs (GB200/B300/H100/A100/Spark), AMD GPUs (MI355/MI300), Intel Xeon CPUs, Google TPUs, Ascend NPUs, and more.
- **Flexible Frontend Language**: Offers an intuitive interface for programming LLM applications, supporting chained generation calls, advanced prompting, control flow, multi-modal inputs, parallelism, and external interactions.
- **Active Community**: SGLang is open-source and supported by a vibrant community with widespread industry adoption, powering over 300,000 GPUs worldwide.

# Supported tags and respective Dockerfile links

The tag of each vLLM docker image is consist of the version of vLLM and the version of basic image. The details are as follows

| Tags | Currently |  Architectures|
|--|--|--|
|[0.5.5-torch2.8.0-cuda12.4-python3.11-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/sglang/0.5.5-torch2.8.0-cuda12.4-python3.11/24.03-lts-sp2/Dockerfile)| SGLang 0.5.5 on openEuler 24.03-LTS-SP2 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Intel/AMD x86
- ARM AArch64

## Quick start 2: pull the SGLang image

```bash
docker pull openeuler:sglang:{TAG}
```
## Quick start 3: offline inference

You can use Modelscope mirror to speed up download:

```bash
docker run --rm --name sglang -p 8000:8000 --gpus all openeuler/sglang:{TAG} python3 -m sglang.launch_server --model-path {MODEL_PATH} --host 0.0.0.0 -port 8000
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
