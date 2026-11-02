import os
from fastapi import FastAPI
from pydantic import BaseModel
from sentence_transformers import SentenceTransformer

model = SentenceTransformer(os.getenv("EMB_MODEL_PATH", "/data"))
app = FastAPI(title="st-embed (OpenAI compatible)")

class EmbReq(BaseModel):
    model: str = "bge-m3"
    input: list | str

@app.get("/health")
def h(): return {"ok": True}

@app.post("/v1/embeddings")
def emb(r: EmbReq):
    texts = r.input if isinstance(r.input, list) else [r.input]
    vecs = model.encode(texts, normalize_embeddings=True).tolist()
    return {"object": "list",
            "data": [{"object": "embedding", "index": i, "embedding": v} for i, v in enumerate(vecs)],
            "model": r.model, "usage": {"prompt_tokens": 0, "total_tokens": 0}}
