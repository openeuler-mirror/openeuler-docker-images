# Quick reference

- The official SGLang artifact docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# SGLang | openEuler

SGLang is a fast serving framework for large language models (LLMs) and vision language models. It provides high-performance inference capabilities through co-designed backend runtime and frontend language. Learn more at https://github.com/sgl-project/sglang.

# Supported tags and respective Dockerfile links

The tag of each SGLang docker image is consist of the version of SGLang and the version of basic image. The details are as follows:

| Tags | Currently | Architectures |
|------|-----------|---------------|
|[0.5.13-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/sglang/0.5.13/24.03-lts-sp3/Dockerfile) | sglang 0.5.13 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
|[0.5.12-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/sglang/0.5.12/24.03-lts-sp3/Dockerfile) | sglang 0.5.12 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
|[0.5.11-24.03-lts-sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/sglang/0.5.11/24.03-lts-sp3/Dockerfile)| sglang 0.5.11 on openEuler 24.03-lts-sp3 | amd64, arm64 |

# Usage

In this usage, users can select the corresponding `{Tag}` based on their requirements. Build artifacts are placed under `/opt/sglang` inside the image.

Pull the image (example):

```bash
docker pull my-registry/sglang:0.5.11
```

Check SGLang installation:

```bash
docker run --rm my-registry/sglang:0.5.11 python3 -c "import sglang; print(sglang.__version__)"
```

View available parameters:

```bash
docker run --rm my-registry/sglang:0.5.11 python3 -m sglang.launch_server --help
```

## Starting SGLang Server

Start the SGLang inference server (example):

```bash
docker run --gpus all \
  -p 30000:30000 \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  my-registry/sglang:0.5.11 \
  python3 -m sglang.launch_server \
    --model-path meta-llama/Llama-3.1-8B-Instruct \
    --host 0.0.0.0 \
    --port 30000
```

## Using on Kubernetes (recommended: Deployment)

Deploy SGLang as a Kubernetes Deployment with GPU support. Example:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sglang-server
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sglang-server
  template:
    metadata:
      labels:
        app: sglang-server
    spec:
      containers:
        - name: sglang
          image: my-registry/sglang:0.5.11
          ports:
            - containerPort: 30000
          args:
            - python3
            - -m
            - sglang.launch_server
            - --model-path
            - meta-llama/Llama-3.1-8B-Instruct
            - --host
            - "0.0.0.0"
            - --port
            - "30000"
          resources:
            requests:
              nvidia.com/gpu: 1
            limits:
              nvidia.com/gpu: 1
          volumeMounts:
            - name: huggingface-cache
              mountPath: /root/.cache/huggingface
      volumes:
        - name: huggingface-cache
          persistentVolumeClaim:
            claimName: huggingface-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: sglang-service
spec:
  type: LoadBalancer
  ports:
    - port: 30000
      targetPort: 30000
  selector:
    app: sglang-server
```

## Using with OpenAI-Compatible API

After starting the server, you can interact with SGLang using the OpenAI-compatible API:

```bash
# Chat completions API
curl http://localhost:30000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "meta-llama/Llama-3.1-8B-Instruct",
    "messages": [
      {"role": "user", "content": "Hello, how are you?"}
    ],
    "max_tokens": 256
  }'

# Completions API
curl http://localhost:30000/v1/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "meta-llama/Llama-3.1-8B-Instruct",
    "prompt": "The capital of France is",
    "max_tokens": 32
  }'
```

# Question and answering

If you have any questions or want to use special features, please submit an issue or a pull request on `https://atomgit.com/openeuler/openeuler-docker-images`.