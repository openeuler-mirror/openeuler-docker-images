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
|[cann7.0.RC1.alpha002-oe2203sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/cann/7.0.RC1.alpha002/22.03-lts-sp2/Dockerfile)| CANN 7.0.RC1.alpha002 on openEuler 22.03-LTS-SP2 | arm64 |
|[cann8.0.RC1-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/cann/8.0.RC1/22.03-lts-sp4/Dockerfile)| CANN 8.0.RC1 with Python 3.8 on openEuler 22.03-LTS-SP4 | arm64,amd64 |

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
    | `--device /dev/davinci1` | Mounts the specific hardware device `/dev/davinci1` into the container. |
    | `--device /dev/davinci_manager` | Mounts the specific hardware device `/dev/davinci_manager` into the container. |
    | `--device /dev/devmm_svm` | Mounts the specific hardware device `/dev/devmm_svm` into the container. |
    | `--device /dev/hisi_hdc` | Mounts the specific hardware device `/dev/hisi_hdc` into the container. |
	| `-v /usr/local/dcmi:/usr/local/dcmi` | Mounts the directory `/usr/local/dcmi` from the host to the container at the same path. |
    | `-v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi` | Mounts the directory `/usr/local/bin/npu-smi` from the host to the container at the same path. |
    | `-v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/` | Mounts the directory `/usr/local/Ascend/driver/lib64/` from the host to the container at the same path. |
    | `-v /usr/local/Ascend/driver/version.info:/usr/local/Ascend/driver/version.info` | Mounts the directory `/usr/local/Ascend/driver/version.info` from the host to the container at the same path. |
    | `-v /etc/ascend_install.info:/etc/ascend_install.info` | Mounts the directory `/etc/ascend_install.info` from the host to the container at the same path. |
    | `-it` | Starts the container in interactive mode with a terminal (bash). |
    | `openeuler/cann:{Tag}` | Specifies the Docker image to run, replace {Tag} with the specific version or tag of the openeuler/cann image you want to use. |

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