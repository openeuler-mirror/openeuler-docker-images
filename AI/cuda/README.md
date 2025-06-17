# Quick reference

- The official CUDA docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# CUDA | openEuler
Current CUDA docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

AI-oriented heterogeneous compute architecture provides hierarchical APIs to help you quickly build AI applications and services based on the Ascend platform.

Learn more about on [CUDA Document](https://docs.nvidia.com/cuda/).

# Supported tags and respective Dockerfile links
The tag of each `cuda` docker image is consist of the complete software stack version. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[11.8.0-python3.10-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/cuda/11.8.0-python3.10/22.03-lts/Dockerfile)| CUDA 11.8.0 with Python 3.10 on openEuler 22.03-LTS | arm64,amd64 |

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
        --device /dev/davinci1 \
        --device /dev/davinci_manager \
        --device /dev/devmm_svm \
        --device /dev/hisi_hdc \
        -v /usr/local/dcmi:/usr/local/dcmi \
        -v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \
        -v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/ \
        -v /usr/local/Ascend/driver/version.info:/usr/local/Ascend/driver/version.info \
        -v /etc/ascend_install.info:/etc/ascend_install.info \
        -it openeuler/cuda:{Tag} bash
	```

- Container startup options

	| Option | Description |
	|--|--|
    | `--name my-cuda` | Names the container `my-cuda`. |
    | `--device /dev/davinciX` | NPU device, where `X` is the physical ID number of the chip, e.g., davinci1. |
    | `--device /dev/davinci_manager` | Davinci-related management device. |
    | `--device /dev/devmm_svm` | Memory management-related device. |
    | `--device /dev/hisi_hdc` | 	HDC-related management device. |
	| `-v /usr/local/dcmi:/usr/local/dcmi` | Mounts the host's DCMI .so and interface file directory /usr/local/dcmi to the container. Please modify according to actual situation. |
    | `-v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi` | Mount the host npu-smi tool "/usr/local/bin/npu-smi" into the container. Please modify it according to the actual situation. |
    | `-v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/` | Mounts the host directory /usr/local/Ascend/driver/lib64/driver to the container. Please modify according to the path where the driver's .so files are located. |
    | `-v /usr/local/Ascend/driver/version.info:/usr/local/Ascend/driver/version.info` | Mounts the host's version information file /usr/local/Ascend/driver/version.info to the container. Please modify according to actual situation. |
    | `-v /etc/ascend_install.info:/etc/ascend_install.info` | Mounts the host's installation information file /etc/ascend_install.info to the container. |
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