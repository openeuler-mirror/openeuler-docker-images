# Quick reference

- The official PyTorch docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# KServe | openEuler
Current KServe docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

KServe provides a Kubernetes [Custom Resource Definition](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) for serving predictive and generative machine learning (ML) models. 
It aims to solve production model serving use cases by providing high abstraction interfaces for Tensorflow, XGBoost, ScikitLearn, PyTorch, Huggingface Transformer/LLM models using standardized data plane protocols.

It encapsulates the complexity of autoscaling, networking, health checking, and server configuration to bring cutting edge serving features like GPU Autoscaling, Scale to Zero, and Canary Rollouts to your ML deployments. 
It enables a simple, pluggable, and complete story for Production ML Serving including prediction, pre-processing, post-processing and explainability. 
KServe is being [used across various organizations](https://kserve.github.io/website/master/community/adopters/).

For more details, visit the [KServe website](https://kserve.github.io/website/).

# Supported tags and respective Dockerfile links
The tag of each `KServe` docker image is consist of the complete software stack version. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[0.15.2-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/kserve/controller/0.15.2/24.03-lts/Dockerfile)| KServe controller 0.15.2 on openEuler 24.03-LTS | amd64 |

# Usage

## Before you begin

> KServe Quickstart Environments are for experimentation use only. For production installation, see our [Administrator's Guide](https://kserve.github.io/website/latest/admin/serverless/serverless/).

Before you can get started with a KServe Quickstart deployment you must install kind and the Kubernetes CLI.

### Install Kind (Kubernetes in Docker)

You can use [kind](https://kind.sigs.k8s.io/docs/user/quick-start) (Kubernetes in Docker) to run a local Kubernetes cluster with Docker container nodes.

### Install the Kubernetes CLI

The [Kubernetes CLI (kubectl)](https://kubernetes.io/docs/tasks/tools/install-kubectl), allows you to run commands against Kubernetes clusters. You can use kubectl to deploy applications, inspect and manage cluster resources, and view logs.

### Install Helm

The [Helm](https://helm.sh/docs/intro/install/) package manager for Kubernetes helps you define, install and upgrade software built for Kubernetes.

## Install the KServe environment

After having kind installed, create a kind cluster with:
```shell
kind create cluster
```

Then run:
```shell
kubectl config get-contexts
```

It should list out a list of contexts you have, one of them should be kind-kind. Then run:
```shell
kubectl config use-context kind-kind
```
to use this context.

You can then get started with a local deployment of KServe by using KServe Quick installation script on Kind:
```shell
curl -s "https://gitee.com/openeuler-docker-images/raw//master/AI/kserve/controller/doc/quick_install.sh" | bash
```

## Deploy the Llama3 model for text_generation task with Hugging Face LLM Serving Runtime

In this example, We demonstrate how to deploy Llama3 model for text generation task from Hugging Face by deploying the InferenceService with [Hugging Face Serving runtime](https://github.com/kserve/kserve/tree/master/python/huggingfaceserver).

## Serve the Hugging Face LLM model using vLLM backend

KServe Hugging Face runtime by default uses vLLM to serve the LLM models for faster time-to-first-token(TTFT) and higher token generation throughput than the Hugging Face API. 
vLLM is implemented with common inference optimization techniques, such as paged attention, continuous batching and an optimized CUDA kernel. 
If the model is not supported by vLLM, KServe falls back to HuggingFace backend as a failsafe.

> The Llama3 model requires huggingface hub token to download the model. 
You can set the token using HF_TOKEN environment variable.

Create a secret with the Hugging Face token.
```yaml
apiVersion: v1
kind: Secret
metadata:
    name: hf-secret
type: Opaque    
stringData:
    HF_TOKEN: <token>
```

Then create the inference service.
```yaml
kubectl apply -f - <<EOF
apiVersion: serving.kserve.io/v1beta1
kind: InferenceService
metadata:
  name: huggingface-llama3
spec:
  predictor:
    model:
      modelFormat:
        name: huggingface
      args:
        - --model_name=llama3
        - --model_id=meta-llama/meta-llama-3-8b-instruct
      env:
        - name: HF_TOKEN
          valueFrom:
            secretKeyRef:
              name: hf-secret
              key: HF_TOKEN
              optional: false
      resources:
        limits:
          cpu: "6"
          memory: 24Gi
          nvidia.com/gpu: "1"
        requests:
          cpu: "6"
          memory: 24Gi
          nvidia.com/gpu: "1"
EOF

```

Check InferenceService status.
```shell
kubectl get inferenceservices huggingface-llama3
```

Expected output:
```shell
NAME                 URL                                                   READY   PREV   LATEST   PREVROLLEDOUTREVISION   LATESTREADYREVISION                          AGE
huggingface-llama3   http://huggingface-llama3.default.example.com         True           100                              huggingface-llama3-predictor-default-47q2g   7d23h
```

## Perform Model Inference

The first step is to [determine the ingress IP](https://kserve.github.io/website/latest/get_started/first_isvc/#4-determine-the-ingress-ip-and-ports) and ports and set `INGRESS_HOST` and `INGRESS_PORT`.
```shell
MODEL_NAME=llama3
SERVICE_HOSTNAME=$(kubectl get inferenceservice huggingface-llama3 -o jsonpath='{.status.url}' | cut -d "/" -f 3)
```

KServe Hugging Face vLLM runtime supports the OpenAI `/v1/completions` and `/v1/chat/completions` endpoints for `inference`.

Sample OpenAI Completions request:
```shell
curl -v http://${INGRESS_HOST}:${INGRESS_PORT}/openai/v1/completions \
-H "content-type: application/json" -H "Host: ${SERVICE_HOSTNAME}" \
-d '{"model": "llama3", "prompt": "Write a poem about colors", "stream":false, "max_tokens": 30}'
```

Expected output:
```shell
{
  "id": "cmpl-625a9240f25e463487a9b6c53cbed080",
  "choices": [
    {
      "finish_reason": "length",
      "index": 0,
      "logprobs": null,
      "text": " and how they make you feel\nColors, oh colors, so vibrant and bright\nA world of emotions, a kaleidoscope in sight\nRed"
    }
  ],
  "created": 1718620153,
  "model": "llama3",
  "system_fingerprint": null,
  "object": "text_completion",
  "usage": {
    "completion_tokens": 30,
    "prompt_tokens": 6,
    "total_tokens": 36
  }
}
```
