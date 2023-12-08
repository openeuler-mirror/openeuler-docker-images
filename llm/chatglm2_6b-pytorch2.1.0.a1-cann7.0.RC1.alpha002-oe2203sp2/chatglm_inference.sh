#!/bin/bash
source activate torch_npu
ports=("21001" "21002" "7860")
for port in "${ports[@]}"
do
    info=$(netstat -tunpl | grep ":$port ")
    pid=$(echo "$info" | awk '{print $7}' | awk -F'/' '{print $1}')
    if [[ -n "$pid" ]]; then
        kill "$pid"
    fi
done

cd /FastChat
python -m fastchat.serve.controller --host 0.0.0.0 &
sleep 3
python -m fastchat.serve.model_worker --model-path /chatglm2-6b/ --device npu --host 0.0.0.0 &
sleep 65
python -m fastchat.serve.gradio_web_server --host 0.0.0.0 &
