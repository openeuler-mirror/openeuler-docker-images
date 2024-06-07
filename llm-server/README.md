# 支持百川、chatglm、星火等AI大模型的容器化封装

已配好相关依赖，分为CPU和GPU版本，降低使用门槛，开箱即用。

### 启动方式
docker-compose
```
version: '3'
services:
  model:
    image: openeuler/llm-server:1.0.0.gpu-oe2203sp3   #镜像名称与Tag
    restart: on-failure:5
    ports:
      - 10011:8000    #监听端口号，修改“10011”以更换端口
    volumes:
      - /root/models:/models
    environment:
      - MODEL=/models/qwen1_5-7b-chat-q4_k_m.gguf  #容器内的模型文件路径
      - MODEL_NAME=qwen1.5  #模型名称
      - KEY=sk-12345678  #API Key
      - CONTEXT=8192  #上下文大小
      - THREADS=8    #CPU线程数，仅CPU部署时需要
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
```
```
docker-compose -f docker-compose.yaml up
```
或者
```
docker run -d --gpus all --restart on-failure:5 -p 宿主机端口:容器端口(默认8000) -v 宿主机模型挂载路径:/models -e MODEL=/models/模型名(gguf格式) -e MODEL_NAME=baichuan-7b(自定义模型名称) -e KEY=sk-12345678(api key) image_name:tag
```