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

The tag of each Text2Image docker image is consist of the version of Text2Image and the version of basic image. The details are as follows

| Tags | Currently |  Architectures|
|--|--|--|
|[1.2-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/opea/text2image/1.2/24.03-lts/Dockerfile)| Text2Image 1.2 on openEuler 24.03-LTS | amd64 |

# Usage

The Text2Image service can be effortlessly deployed on either Intel Gaudi2 or Intel Xeon Scalable Processor.

Currently we support two ways of deploying Text2Image services with docker compose:

1. Start services using the docker image on `docker hub`:

   ```bash
   docker pull openeuler/text2image:latest
   docker pull openeuler/text2image-ui:latest
   ```

2. Start services using the docker images built from source.

### Quick Start: 1.Setup Environment Variable

To set up environment variables for deploying Text2Image services, follow these steps:

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

### Quick Start: 2.Run Docker Compose 

> Get `compose.yml` here: [compose.yml](https://gitee.com/openeuler/openeuler-docker-images/tree/master/AI/opea/text2image/doc/compose.yml)

```bash
docker compose -f compose.yml up -d
```

It will automatically download the docker image on `docker hub`:

```bash
docker pull openeuler/text2image:latest
docker pull openeuler/text2image-ui:latest
```

### QuickStart: 3.Consume the Text2Image Service

1. Access via frontend

   To access the frontend, open the following URL in your browser: `http://{host_ip}:5173`.

   By default, the UI runs on port 5173 internally.