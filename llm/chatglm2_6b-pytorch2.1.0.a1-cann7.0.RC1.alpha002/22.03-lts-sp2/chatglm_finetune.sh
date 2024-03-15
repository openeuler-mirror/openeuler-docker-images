#!/bin/bash
ports=("21001" "21002" "7860")
for port in "${ports[@]}"
do
    info=$(netstat -tunpl | grep ":$port ")
    pid=$(echo "$info" | awk '{print $7}' | awk -F'/' '{print $1}')
    if [[ -n "$pid" ]]; then
        kill "$pid"
    fi
done
torchrun --nproc_per_node=4 --master_port=20001 /FastChat/fastchat/train/train.py \
    --model_name_or_path /chatglm2-6b \
    --data_path /demo/openeuler-finetune.json \
    --fp16 True \
    --output_dir output_chatglm \
    --num_train_epochs 5 \
    --per_device_train_batch_size 8 \
    --per_device_eval_batch_size 1 \
    --gradient_accumulation_steps 1 \
    --evaluation_strategy "no" \
    --save_strategy "epoch" \
    --learning_rate 5e-5 \
    --weight_decay 0. \
    --lr_scheduler_type "cosine" \
    --logging_steps 1 \
    --fsdp "full_shard auto_wrap" \
    --model_max_length 512 \
    --gradient_checkpointing True \
    --lazy_preprocess True \
    --trust_remote_code True
