# Quick reference

- The offical OPEA docker images

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# OPEA | openEuler

Current OPEA docker images are built on the [openEuler](https://repo.openeuler.org/)⁠. This repository is free to use and exempted from per-user rate limits.

OPEA is an open platform project that lets you create open, multi-provider, robust, and composable GenAI solutions that harness the best innovation across the ecosystem.

The OPEA platform includes:

- Detailed framework of composable building blocks for state-of-the-art generative AI systems including LLMs, data stores, and prompt engines

- Architectural blueprints of retrieval-augmented generative AI component stack structure and end-to-end workflows

- A four-step assessment for grading generative AI systems around performance, features, trustworthiness, and enterprise-grade readiness

Read more about OPEA at [opea.dev](https://opea.dev/) and explore the OPEA technical documentation at [opea-project.github.io](https://opea-project.github.io/)

# Supported tags and respective Dockerfile links

The tag of each SearchQnA docker image is consist of the version of SearchQnA and the version of basic image. The details are as follows

| Tags | Currently |  Architectures|
|--|--|--|
|[1.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/opea/searchqna/1.0/24.03-lts/Dockerfile)| SearchQnA 1.0 on openEuler 24.03-LTS | amd64 |
|[1.2-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/opea/searchqna/1.2/24.03-lts/Dockerfile)| SearchQnA 1.2 on openEuler 24.03-LTS | amd64 |

# Usage

The SearchQnA service can be effortlessly deployed on Intel Gaudi2, Intel Xeon Scalable Processors and Nvidia GPU.

Two types of SearchQnA pipeline are supported now: `SearchQnA with/without Rerank`. And the `SearchQnA without Rerank` pipeline (including Embedding, Retrieval, and LLM) is offered for Xeon customers who can not run rerank service on HPU yet require high performance and accuracy.

Quick Start Deployment Steps:

1. Set up the environment variables.
2. Run Docker Compose.
3. Consume the SearchQnA Service.

### Quick Start: 1.Setup Environment Variable

To set up environment variables for deploying SearchQnA services, follow these steps:

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

   > Get `set_env.sh` here: [set_env.sh](https://gitee.com/openeuler/openeuler-docker-images/tree/master/AI/opea/searchqna/doc/set_env.sh)

   ```bash 
   # on Xeon
   source set_env.sh
   ```

### Quick Start: 2.Run Docker Compose 

Select the compose.yaml file that matches your hardware.

CPU example:

> Get `compose.yml` here: [compose.yml](https://gitee.com/openeuler/openeuler-docker-images/tree/master/AI/opea/searchqna/doc/compose.yml)

```bash
docker compose -f compose.yml up -d
```

It will automatically download the docker image on `docker hub`:

```bash
docker pull openeuler/searchqna:latest
docker pull openeuler/searchqna-ui:latest
```

### QuickStart: 3.Consume the SearchQnA Service

```bash
curl http://${host_ip}:3008/v1/searchqna -H "Content-Type: application/json" -d '{
     "messages": "What is the latest news? Give me also the source link.",
     "stream": "True"
     }'
```