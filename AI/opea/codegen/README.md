# Quick reference

- The offical OPEA docker images

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# OPEA | openEuler

Current Redis docker images are built on the [openEuler](https://repo.openeuler.org/)⁠. This repository is free to use and exempted from per-user rate limits.

OPEA is an open platform project that lets you create open, multi-provider, robust, and composable GenAI solutions that harness the best innovation across the ecosystem.

The OPEA platform includes:

- Detailed framework of composable building blocks for state-of-the-art generative AI systems including LLMs, data stores, and prompt engines

- Architectural blueprints of retrieval-augmented generative AI component stack structure and end-to-end workflows

- A four-step assessment for grading generative AI systems around performance, features, trustworthiness, and enterprise-grade readiness

Read more about OPEA at [opea.dev](https://opea.dev/) and explore the OPEA technical documentation at [opea-project.github.io](https://opea-project.github.io/)

# Supported tags and respective Dockerfile links

The tag of each CodeGen docker image is consist of the version of CodeGen and the version of basic image. The details are as follows

| Tags | Currently |  Architectures|
|--|--|--|
|[1.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/opea/codegen/1.0/24.03-lts/Dockerfile)| CodeGen 1.0 on openEuler 24.03-LTS | amd64 |

# Usage

The CodeGen service can be effortlessly deployed on either Intel Gaudi2 or Intel Xeon Scalable Processor.

Currently we support two ways of deploying CodeGen services with docker compose:

1. Start services using the docker image on `docker hub`:

   ```bash
   docker pull openeuler/codegen:latest
   ```

2. Start services using the docker images built from source.

### Required Models

By default, the LLM model is set to a default value as listed below:

| Service      | Model                                                                           |
| ------------ | ------------------------------------------------------------------------------- |
| LLM_MODEL_ID | [meta-llama/CodeLlama-7b-hf](https://huggingface.co/meta-llama/CodeLlama-7b-hf) |

[meta-llama/CodeLlama-7b-hf](https://huggingface.co/meta-llama/CodeLlama-7b-hf) is a gated model that requires submitting an access request through Hugging Face. You can replace it with another model.
Change the `LLM_MODEL_ID` below for your needs, such as: [Qwen/CodeQwen1.5-7B-Chat](https://huggingface.co/Qwen/CodeQwen1.5-7B-Chat), [deepseek-ai/deepseek-coder-6.7b-instruct](https://huggingface.co/deepseek-ai/deepseek-coder-6.7b-instruct)

If you choose to use `meta-llama/CodeLlama-7b-hf` as LLM model, you will need to visit [here](https://huggingface.co/meta-llama/CodeLlama-7b-hf), click the `Expand to review and access` button to ask for model access.

### Quick Start: 1.Setup Environment Variable

To set up environment variables for deploying CodeGen services, follow these steps:

1. Set the required environment variables:

   ```bash
   # Example: host_ip="192.168.1.1"
   export host_ip="External_Public_IP"
   # Example: no_proxy="localhost, 127.0.0.1, 192.168.1.1"
   export no_proxy="Your_No_Proxy"
   export HUGGINGFACEHUB_API_TOKEN="Your_Huggingface_API_Token"
   ```

2. If you are in a proxy environment, also set the proxy-related environment variables:

   ```bash
   export http_proxy="Your_HTTP_Proxy"
   export https_proxy="Your_HTTPs_Proxy"
   ```

3. Set up other environment variables:

   > Get `set_env.sh` here: [set_env.sh](https://gitee.com/openeuler/openeuler-docker-images/tree/master/AI/opea/codegen/doc/set_env.sh) 

   ```bash
   source set_env.sh
   ```

### Quick Start: 2.Run Docker Compose 

> Get `compose.yml` here: [compose.yml](https://gitee.com/openeuler/openeuler-docker-images/tree/master/AI/opea/codegen/doc/compose.yml)

```bash
docker compose -f compose.yml up -d
```

It will automatically download the docker image on `docker hub`:

```bash
docker pull openeuler/codegen:latest
docker pull openeuler/codegen-ui:latest
```

### QuickStart: 3.Consume the CodeGen Service

1. Use cURL command on terminal

   ```bash
   curl http://${host_ip}:7778/v1/codegen \
       -H "Content-Type: application/json" \
       -d '{"messages": "Implement a high-level API for a TODO list application. The API takes as input an operation request and updates the TODO list in place. If the request is invalid, raise an exception."}'
   ```

2. Access via frontend

   To access the frontend, open the following URL in your browser: http://{host_ip}:5173.

   By default, the UI runs on port 5173 internally.
