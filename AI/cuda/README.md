# Quick reference

- The official CUDA docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# CUDA | openEuler
Current CUDA docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

A heterogeneous computing platform for general-purpose parallel computing that provides layered APIs and high-level libraries to help you quickly build high-performance computing applications and AI services based on NVIDIA GPUs.

Learn more about on [CUDA Document](https://docs.nvidia.com/cuda/).

# Supported tags and respective Dockerfile links
The tag of each `cuda` docker image is consist of the complete software stack version. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[11.8.0-cudnn8.9.0-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/cuda/11.8.0-cudnn8.9.0/22.03-lts/Dockerfile)| CUDA 11.8.0 with cudnn 8.9.0 on openEuler 22.03-LTS | arm64,amd64 |
|[13.0.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/cuda/13.0.0/24.03-lts/Dockerfile)| CUDA 13.0.0 on openEuler 24.03-LTS | arm64,amd64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/cudas` image from docker

	```bash
	docker pull openeuler/cuda:{Tag}
	```

- Start a cann instance

	```bash
	docker run \
        --name my-cuda \
        --gpus all \
        -it openeuler/cuda:{Tag} bash
	```

- Container startup options

	| Option | Description |
	|--|--|
    | `--name my-cuda` | Names the container `my-cuda`. |
    | `--gpus all` | The specified container can access all GPU devices, you can also specify a specific GPU, such as --gpus '"device=0,1"' |
    | `-it` | Starts the container in interactive mode with a terminal (bash). |
    | `openeuler/cuda:{Tag}` | Specifies the Docker image to run, replace `{Tag}` with the specific version or tag of the `openeuler/cuda` image you want to use. |

- View container running logs

	```bash
	docker logs -f my-cuda
	```

- To get an interactive shell

	```bash
	docker exec -it my-cuda /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).