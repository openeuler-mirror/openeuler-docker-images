# Quick reference

- Self-hosted Mem0 REST API for openEuler: a thin service around `mem0ai` with Milvus as the vector store.

- Maintained by: [unac](https://atomgit.com/unac)

- Where to get help: https://github.com/mem0ai/mem0/issues

# Mem0 | openEuler

This image packages a small FastAPI service around the Mem0 Python SDK (`mem0ai` 2.2.1).
It exposes a REST API for adding and searching long-term memories, backed by Milvus and any
OpenAI-compatible embedding endpoint.

Design notes:

- Bearer-token authentication (`MEM0_TOKEN`, optional but recommended)
- `scope` is mapped to Mem0 `user_id` (for per-package / per-user isolation)
- `infer=false` by default: memory extraction is left to the calling agent, no extra LLM calls
- rejects credential-like content on write (HTTP 422)

# Supported tags and respective Dockerfile links

| Tags | Currently | Architectures |
|--|--|--|
| [2.2.1-oe2403sp4](2.2.1/24.03-lts-sp4/Dockerfile) | mem0ai 2.2.1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

The service needs a Milvus instance and an embedding endpoint (OpenAI-compatible
`/v1/embeddings`). Example with an external `embed` service:

```bash
docker run -d --name mem0 -p 127.0.0.1:8888:8888 \
  -e MEM0_TOKEN=change-me \
  -e MEM0_VECTOR_URL=http://milvus:19530 \
  -e MEM0_COLLECTION=memories \
  -e MEM0_EMBED_DIMS=1024 \
  -e MEM0_EMB_BASE=http://embed:80/v1 \
  -e MEM0_EMB_MODEL=bge-m3 \
  openeuler/mem0:2.2.1-oe2403sp4
```

Endpoints:

| Method | Path | Description |
|---|---|---|
| POST | `/memories` | add memories: `{messages, scope, metadata, infer}` |
| POST | `/search` | search: `{query, scope, top_k}` |
| GET | `/history?scope=...` | memory history for a scope |
| GET | `/healthz` | readiness + embedding dimensions |

# Question and answering

Please open issues at https://github.com/mem0ai/mem0/issues
