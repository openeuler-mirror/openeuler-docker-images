# Quick reference

- The official CANN docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# CANN | openEuler
Current CANN docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

AI-oriented heterogeneous compute architecture provides hierarchical APIs to help you quickly build AI applications and services based on the Ascend platform.

Learn more about on [CANN Document](https://www.hiascend.com/en/document).

# Supported tags and respective Dockerfile links
The tag of each `cann` docker image is consist of the complete software stack version. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[cann7.0.RC1.alpha002-oe2203sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/cann/7.0.RC1.alpha002/22.03-lts-sp2/Dockerfile)| CANN 7.0.RC1.alpha002 on openEuler 22.03-LTS-SP2 | arm64 |
|[8.0.RC1-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/cann/8.0.RC1/22.03-lts-sp4/Dockerfile)| CANN 8.0.RC1 with Python 3.8 on openEuler 22.03-LTS-SP4 | arm64,amd64 |
|[8.1.RC1-python3.11-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/cann/8.1.RC1-python3.11/22.03-lts/Dockerfile)| CANN 8.1.RC1 with Python 3.11 on openEuler 22.03-LTS | arm64,amd64 |
|[8.1.RC1-python3.11-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/cann/8.1.RC1-python3.11/24.03-lts/Dockerfile)| CANN 8.1.RC1 with Python 3.11 on openEuler 24.03-LTS | arm64,amd64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/cann` image from docker

	```bash
	docker pull openeuler/cann:{Tag}
	```

- Start a cann instance

	```bash
	docker run \
        --name my-cann \
        --device /dev/davinci1 \
        --device /dev/davinci_manager \
        --device /dev/devmm_svm \
        --device /dev/hisi_hdc \
        -v /usr/local/dcmi:/usr/local/dcmi \
        -v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \
        -v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/ \
        -v /usr/local/Ascend/driver/version.info:/usr/local/Ascend/driver/version.info \
        -v /etc/ascend_install.info:/etc/ascend_install.info \
        -it openeuler/cann:{Tag} bash
	```

- Container startup options

	| Option | Description |
	|--|--|
    | `--name my-cann` | Names the container `my-cann`. |
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
    | `openeuler/cann:{Tag}` | Specifies the Docker image to run, replace `{Tag}` with the specific version or tag of the `openeuler/cann` image you want to use. |

- View container running logs

	```bash
	docker logs -f my-cann
	```

- To get an interactive shell

	```bash
	docker exec -it my-cann /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).