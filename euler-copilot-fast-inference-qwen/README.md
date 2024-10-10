# Quick reference

# euler-copilot-fast-inference | openEuler
An inference framework that can be used for large-scale CPU inference, based on the Kunpeng and openEuler basic image, containerized package after release, can be used for one-click deployment

# Supported tags and respective Dockerfile links
tags of the current container image: openeuler/euler-copilot-fast-inference-qwen:1.5-oe2203sp3
Link to dockerfile is (https://gitee.com/openeuler/openeuler-docker-images/blob/master/euler-copilot-fast-inference-qwen/1.5/22.03-lts-sp3/Dockerfile)

# Usage：
1. Start the container based on the application image
2. Access the /home/euler-copilot-fast-inference directory to get the inference process
3. Specify the large model path and execute the inference process
4. Specify the large model path as the first argument, using -i to specify the input prompt word
5. View model inference results
6. example
    download: |
      Due to the large size of euler-copilot-fast-inference image, it is recommended to pull it locally separately before starting the container:

      ```
        docker pull openeuler/euler-copilot-fast-inference:{Tag}
      ```
    
    usage: |
      - download[qwen1_5-7b-chat-q4_0.gguf](https://hf-mirror.com/Qwen/Qwen1.5-7B-Chat-GGUF/tree/main)
        ```
          wget https://hf-mirror.com/Qwen/Qwen1.5-7B-Chat-GGUF/resolve/main/qwen1_5-7b-chat-q4_0.gguf
        ```
      
      - start docker，copy weight file into docker，start inference
        ```
          # cd source code
          cd euler-copilot-fast-inference
          # start docker
          docker run --name **** -it -d --net=host --privileged=true --entrypoint=bash openeuler/euler-copilot-fast-inference-qwen:1.5-oe2203sp3
          # start inference
          docker exec -it <name> bash
          cd /home/euler-copilot-fast-inference
          # example
          ./fast-llm qwen1_5-7b-chat-q4_0.gguf -t 0.0 -i "中国最高的山峰是?" -n 64
        ```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).