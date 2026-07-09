# Quick reference

- The official tensorrt-llm docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# TensorRT-LLM | openEuler
TensorRT LLM provides users with an easy-to-use Python API to define Large Language Models (LLMs) and supports state-of-the-art optimizations to perform inference efficiently on NVIDIA GPUs. TensorRT LLM also contains components to create Python and C++ runtimes that orchestrate the inference execution in a performant way.


# Supported tags and respective Dockerfile links
The tag of each TensorRT-LLM docker image is consist of the version of TensorRT-LLM and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.2.1-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/tensorrt-llm/1.2.1/24.03-lts-sp4/Dockerfile) | tensorrt-llm 1.2.1 on openEuler 24.03-lts-sp4 | amd64, arm64 |
|[1.2.1-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/tensorrt-llm/1.2.1/24.03-lts-sp3/Dockerfile) | tensorrt-llm 1.2.1 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
This image provides the TensorRT LLM inference environment with CUDA 13.1 and PyTorch 2.9.To run the container with GPU support:

```
docker run -it --gpus all --name trtllm-dev openeuler/tensorrt-llm:{Tag}
```

Once inside the container, verify the installation:

```
python3 -c "from tensorrt_llm import LLM; print('TensorRT LLM ready')"
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
