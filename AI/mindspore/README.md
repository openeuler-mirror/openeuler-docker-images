# Quick reference

- The official MindSpore docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# MindSpore | openEuler
Current MindSpore docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

MindSpore is a new open source deep learning training/inference framework that could be used for mobile, edge and cloud scenarios. MindSpore is designed to provide development experience with friendly design and efficient execution for the data scientists and algorithmic engineers, native support for Ascend AI processor, and software hardware co-optimization. At the meantime MindSpore as a global AI open source community, aims to further advance the development and enrichment of the AI software/hardware application ecosystem.

For more details please check out our [Architecture Guide](https://www.mindspore.cn/tutorials/en/master/beginner/introduction.html)⁠.

# Supported tags and respective Dockerfile links
The tag of each `mindspore` docker image is consist of the complete software stack version. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[2.3.0rc1-cann8.0.RC1-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/mindspore/2.3.0.rc1-cann8.0.RC1/22.03-lts-sp4/Dockerfile)| MindSpore 2.3.0.rc1 with CANN 8.0.RC1 on openEuler 22.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/mindspore` image from docker

	```bash
	docker pull openeuler/mindspore:{Tag}
	```

- Start a mindspore instance

	```bash
	docker run \
        --name my-mindspore \
        --device /dev/davinci1 \
        --device /dev/davinci_manager \
        --device /dev/devmm_svm \
        --device /dev/hisi_hdc \
        -v /usr/local/dcmi:/usr/local/dcmi \
        -v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \
        -v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/ \
        -v /usr/local/Ascend/driver/version.info:/usr/local/Ascend/driver/version.info \
        -v /etc/ascend_install.info:/etc/ascend_install.info \
        -it openeuler/mindspore:{Tag} bash
	```

- Container startup options

	| Option | Description |
	|--|--|
    | `--name my-mindspore` | Names the container `my-mindspore`. |
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
    | `openeuler/mindspore:{Tag}` | Specifies the Docker image to run, replace `{Tag}` with the specific version or tag of the `openeuler/mindspore` image you want to use. |

- View container running logs

	```bash
	docker logs -f my-mindspore
	```

- To get an interactive shell

	```bash
	docker exec -it my-mindspore /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).