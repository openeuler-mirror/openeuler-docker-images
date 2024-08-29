# Quick reference

# euler-copilot-fast-inference | openEuler
An inference framework that can be used for large-scale CPU inference, based on the Kunpeng and openEuler basic image, containerized package after release, can be used for one-click deployment

# Supported tags and respective Dockerfile links
tags of the current container image: openeuler/euler-copilot-fast-inference:1.0.0-oe2203sp3
Link to dockerfile is (https://gitee.com/openeuler/openeuler-docker-images/blob/master/euler-copilot-fast-inference/1.0.0/22.03-lts-sp3/Dockerfile)

# Usage：
1. Start the container based on the application image
2. Access the /home/euler-copilot-fast-inference directory to get the inference process
3. Specify the large model path and execute the inference process
4. Specify the large model path as the first argument, using -i to specify the input prompt word
5. View model inference results
6. example
    download: |
      由于euler-copilot-fast-inference镜像体积较大，建议单独pull到本地后再启动容器：
      ```
        docker pull openeuler/euler-copilot-fast-inference:{Tag}
      ```
    
    usage: |
      - 下载[qwen1_5-7b-chat-q4_0.gguf](https://hf-mirror.com/Qwen/Qwen1.5-7B-Chat-GGUF/tree/main)权重文件
        ```
          wget https://hf-mirror.com/Qwen/Qwen1.5-7B-Chat-GGUF/resolve/main/qwen1_5-7b-chat-q4_0.gguf
        ```
      
      - 启动docker容器，cp权重文件，执行推理
        ```
          # 进入源码目录
          cd mptcp_net-next
          # 启动容器
          docker run --name **** -it -d --net=host --privileged=true --entrypoint=bash openeuler/fast-llm:1.0.0-oe2203sp3
          # copy权重文件
          docker cp qwen1_5-7b-chat-q4_0.gguf <CONTAINER ID>:/home/euler-copilot-fast-inference
          # 进入docker执行推理
          docker exec -it <name> bash
          cd /home/euler-copilot-fast-inference
          # example
          ./fast-llm qwen1_5-7b-chat-q4_0.gguf -t 0.0 -i "中国最高的山峰是?" -n 64
        ```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).