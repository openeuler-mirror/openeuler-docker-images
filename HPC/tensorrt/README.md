# Quick reference

- The official TensorRT docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# TensorRT | openEuler
Current TensorRT docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

NVIDIA® TensorRT™ is an SDK for high-performance deep learning inference on NVIDIA GPUs. This repository contains the open source components of TensorRT.

Learn more on [tensorrt Website](https://developer.nvidia.com/tensorrt)⁠.

# Supported tags and respective Dockerfile links
The tag of each `tensorrt` docker image is consist of the version of `tensorrt` and the version of basic image. The details are as follows

| Tag                                                                                                                                | Currently                                 | Architectures |
|------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|---------------|
| [10.9.0.34-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/tensorrt/10.9.0.34/24.03-lts/Dockerfile) | TensorRT 10.9.0.34 on openEuler 24.03-LTS | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/tensorrt` image from docker

	```bash
	docker pull openeuler/tensorrt:{Tag}
	```

- Start a tensorrt instance

    ```
    docker run -it --rm openeuler/tensorrt:{Tag}
    ```
    The `openeuler/tensorrt` image is used to verify the integration between the upstream tensorrt version and openEuler.
        
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).