import os, re
from fastapi import FastAPI, Header, HTTPException
from pydantic import BaseModel
from mem0 import Memory

SECRET = os.getenv("MEM0_TOKEN","")
DIMS = int(os.getenv("MEM0_EMBED_DIMS","1024"))
COLLECTION = os.getenv("MEM0_COLLECTION","memories")
METRIC = os.getenv("MEM0_METRIC","COSINE")
CFG = {
  "vector_store": {"provider":"milvus","config":{
      "url": os.getenv("MEM0_VECTOR_URL","http://milvus:19530"),
      "collection_name":COLLECTION,"embedding_model_dims":DIMS,"metric_type":METRIC,"token":""}},
  "llm": {"provider":"openai","config":{
      "openai_base_url": os.getenv("MEM0_LLM_BASE"), "model": os.getenv("MEM0_LLM_MODEL","deepseek-chat"),
      "api_key": os.getenv("DEEPSEEK_API_KEY","EMPTY"), "temperature":0.1}},
  "embedder": {"provider":"openai","config":{
      "openai_base_url": os.getenv("MEM0_EMB_BASE"), "model": os.getenv("MEM0_EMB_MODEL","bge-m3"),
      "api_key":"EMPTY", "embedding_dims":DIMS}},
}
app = FastAPI(title="mem0 sidecar"); m = Memory.from_config(CFG)
SINK = re.compile(r"(token|password|secret|api[_-]?key)\s*[:=]", re.I)
def auth(x: str = Header(default="")):
    if SECRET and x != f"Bearer {SECRET}": raise HTTPException(401)
class AddReq(BaseModel):
    messages: list; scope: str; metadata: dict = {}; infer: bool = False
class QReq(BaseModel):
    query: str; scope: str; top_k: int = 5
@app.post("/memories")
def add(r: AddReq, authorization: str = Header(default="")):
    auth(authorization)
    for msg in r.messages:
        if SINK.search(msg.get("content","")): raise HTTPException(422,"credential-like content rejected")
    return m.add(r.messages, user_id=r.scope, metadata=r.metadata, infer=r.infer)
@app.post("/search")
def search(r: QReq, authorization: str = Header(default="")):
    auth(authorization)
    try:
        return m.search(r.query, user_id=r.scope, limit=min(r.top_k,10))
    except Exception:
        return m.search(r.query, filters={"user_id": r.scope}, limit=min(r.top_k,10))
@app.delete("/memories/{mid}")
def delete(mid: str, authorization: str = Header(default="")):
    auth(authorization); return m.delete(mid)
@app.get("/history")
def history(scope: str, authorization: str = Header(default="")):
    auth(authorization); return m.history(user_id=scope)
@app.get("/healthz")
def health(): return {"ok":True,"dims":DIMS}
