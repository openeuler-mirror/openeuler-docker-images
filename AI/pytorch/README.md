# Quick reference

- The official PyTorch docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# PyTorch | openEuler
Current PyTorch docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

PyTorch is a Python package that provides two high-level features:
- Tensor computation (like NumPy) with strong GPU acceleration
- Deep neural networks built on a tape-based autograd system

You can reuse your favorite Python packages such as NumPy, SciPy, and Cython to extend PyTorch when needed.

Learn more about on [PyTorch Website](https://pytorch.org/docs/stable/index.html).

# Supported tags and respective Dockerfile links
The tag of each `pytorch` docker image is consist of the complete software stack version. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[pytorch2.1.0.a1-cann7.0.RC1.alpha002-oe2203sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/pytorch/2.1.0.a1-cann7.0.RC1.alpha002/22.03-lts-sp2/Dockerfile)| pyTorch 2.1.0.a1 with cann 7.0.RC1.alpha002 on openEuler 22.03-LTS-SP2 | arm64 |
|[2.2.0-cann8.0.RC1-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/pytorch/2.2.0-cann8.0.RC1/22.03-lts-sp4/Dockerfile)| PyTorch 2.2.0 with CANN 8.0.RC1 on openEuler 22.03-LTS-SP4 | arm64,amd64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/pytorch` image from docker

	```bash
	docker pull openeuler/pytorch:{Tag}
	```

- Start a pytorch instance

	```bash
	docker run \
        --name my-pytorch \
        --device /dev/davinci1 \
        --device /dev/davinci_manager \
        --device /dev/devmm_svm \
        --device /dev/hisi_hdc \
        -v /usr/local/dcmi:/usr/local/dcmi \
        -v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \
        -v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/ \
        -v /usr/local/Ascend/driver/version.info:/usr/local/Ascend/driver/version.info \
        -v /etc/ascend_install.info:/etc/ascend_install.info \
        -it openeuler/pytorch:{Tag} bash
	```

- Container startup options

	| Option | Description |
	|--|--|
    | `--name my-pytorch` | Names the container `my-pytorch`. |
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
    | `openeuler/pytorch:{Tag}` | Specifies the Docker image to run, replace `{Tag}` with the specific version or tag of the `openeuler/pytorch` image you want to use. |

- View container running logs

	```bash
	docker logs -f my-pytorch
	```

- To get an interactive shell

	```bash
	docker exec -it my-pytorch /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
