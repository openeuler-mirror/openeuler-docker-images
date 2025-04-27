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

The tag of each VideoQnA docker image is consist of the version of VideoQnA and the version of basic image. The details are as follows

| Tags | Currently |  Architectures|
|--|--|--|
|[1.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/opea/videoqna/1.0/24.03-lts/Dockerfile)| VideoQnA 1.0 on openEuler 24.03-LTS | amd64 |

# Usage

VideoQnA is a pipeline that retrieves video based on provided user prompt. It uses only the video embeddings to perform vector similarity search in Intel's VDMS vector database and performs all operations on Intel Xeon CPU. The pipeline supports long form videos and time-based search.

The VideoQnA service can be effortlessly deployed on Intel Gaudi2, Intel Xeon Scalable Processors and Nvidia GPU.

Quick Start Deployment Steps:

1. Set up the environment variables.
2. Run Docker Compose.
3. Consume the VideoQnA Service.

### Quick Start: 1.Setup Environment Variable

To set up environment variables for deploying VideoQnA services, follow these steps:

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

   > Get `set_env.sh` here: [set_env.sh](https://gitee.com/openeuler/openeuler-docker-images/tree/master/AI/opea/videoqna/doc/set_env.sh)

   ```bash 
   # on Xeon
   source set_env.sh
   ```

### Quick Start: 2.Run Docker Compose 

Select the compose.yaml file that matches your hardware.

CPU example:

> Get `compose.yml` here: [compose.yml](https://gitee.com/openeuler/openeuler-docker-images/tree/master/AI/opea/videoqna/doc/compose.yml)

```bash
docker compose -f compose.yml up -d
```

It will automatically download the docker image on `docker hub`:

```bash
docker pull openeuler/videoqna:latest
docker pull openeuler/videoqna-ui:latest
```

### QuickStart: 3.Consume the VideoQnA Service

```bash
curl http://${host_ip}:8888/v1/videoqna -H "Content-Type: application/json" -d '{
      "messages": "What is the man doing?",
      "stream": "True"
    }'
```