# Quick reference

- The official Horovod docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Horovod | openEuler
Current horovod docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Horovod is a distributed deep learning training framework for TensorFlow, Keras, PyTorch, and Apache MXNet. The goal of Horovod is to make distributed deep learning fast and easy to use.

Learn more on [Horovod Website](https://horovod.readthedocs.io/en/stable/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `horovod` docker image is consist of the version of `horovod` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[0.28.1-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/horovod/0.28.1/24.03-lts/Dockerfile)| Horovod 0.28.1 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/horovod` image from docker

	```bash
	docker pull openeuler/horovod:{Tag}
	```

- Start a horovod instance

	```bash
	docker run -d --name my-horovod openeuler/horovod:{Tag}
	```
    After the Horovod container starts, it will display version information.
        
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).