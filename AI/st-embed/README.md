# Quick reference

- Sentence-Transformers embedding server for openEuler: an OpenAI-compatible `/v1/embeddings` service.

- Maintained by: [unac](https://atomgit.com/unac)

- Where to get help: https://github.com/huggingface/sentence-transformers/issues

# ST-Embed | openEuler

This image packages a small FastAPI server around `sentence-transformers` 6.2.0. It loads a
model from a mounted directory and exposes an OpenAI-compatible embeddings API.

It exists because the official text-embeddings-inference images are x86_64 only; this image
supports both amd64 and arm64 and is verified with BAAI/bge-m3 (1024-dimensional embeddings).

# Supported tags and respective Dockerfile links

| Tags | Currently | Architectures |
|--|--|--|
| [6.2.0-oe2403sp4](6.2.0/24.03-lts-sp4/Dockerfile) | sentence-transformers 6.2.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

Download the model first (example: BAAI/bge-m3), then mount it at `/data`:

```bash
docker run -d --name embed -p 127.0.0.1:8090:80 \
  -v /opt/models/bge-m3:/data \
  openeuler/st-embed:6.2.0-oe2403sp4
```

Test:

```bash
curl -s http://127.0.0.1:8090/health
curl -s -X POST http://127.0.0.1:8090/v1/embeddings \
  -H 'Content-Type: application/json' \
  -d '{"model":"bge-m3","input":"hello"}'
```

Environment variables:

| Variable | Default | Description |
|---|---|---|
| `EMB_MODEL_PATH` | `/data` | directory containing the sentence-transformers model |

# Question and answering

Please open issues at https://github.com/huggingface/sentence-transformers/issues
