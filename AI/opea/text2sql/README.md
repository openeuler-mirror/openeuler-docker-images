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

The tag of each DBQnA docker image is consist of the version of DBQnA and the version of basic image. The details are as follows

| Tags | Currently |  Architectures|
|--|--|--|
|[1.2-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/opea/text2sql/1.2/24.03-lts/Dockerfile)| DBQnA 1.2 on openEuler 24.03-LTS | amd64 |

# Usage

The DBQnA service can be effortlessly deployed on Intel Gaudi2, Intel Xeon Scalable Processors and Nvidia GPU.

Two types of DBQnA pipeline are supported now: `DBQnA with/without Rerank`. And the `DBQnA without Rerank` pipeline (including Embedding, Retrieval, and LLM) is offered for Xeon customers who can not run rerank service on HPU yet require high performance and accuracy.

Quick Start Deployment Steps:

1. Set up the environment variables.
2. Run Docker Compose.
3. Consume the DBQnA Service.

### Quick Start: 1.Setup Environment Variable

To set up environment variables for deploying DBQnA services, follow these steps:

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

   > Get `set_env.sh` here: [set_env.sh](https://gitee.com/openeuler/openeuler-docker-images/tree/master/AI/opea/text2sql/doc/set_env.sh)

   ```bash 
   # on Xeon
   source set_env.sh
   ```

### Quick Start: 2.Run Docker Compose 

Select the compose.yaml file that matches your hardware.

CPU example:

> Get `compose.yml` here: [compose.yml](https://gitee.com/openeuler/openeuler-docker-images/tree/master/AI/opea/text2sql/doc/compose.yml)

```bash
docker compose -f compose.yml up -d
```

It will automatically download the docker image on `docker hub`:

```bash
docker pull openeuler/text2sql:latest
docker pull openeuler/text2sql-ui:latest
```

### QuickStart: 3.Consume the DBQnA Service

Open this URL `http://{your_ip}:5174` in your browser to access the frontend.
