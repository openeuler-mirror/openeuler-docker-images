#!/bin/bash
set -euxo pipefail

OLLAMA_HOST=0.0.0.0:11434 nohup ollama serve >/tmp/ollama.log 2>&1 &

exec "$@"