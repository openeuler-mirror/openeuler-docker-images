# Quick reference

- The official spdk docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Storage Performance Development Kit (SPDK) | openEuler
Current Storage Performance Development Kit (SPDK) docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

The Storage Performance Development Kit (SPDK) provides a set of tools and libraries for writing high performance, 
scalable, user-mode storage applications. It achieves high performance by moving all of the necessary drivers into 
userspace and operating in a polled mode instead of relying on interrupts, which avoids kernel context switches and 
eliminates interrupt handling overhead.

Learn more about SPDK on [SPDK Website](https://spdk.io/doc/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `spdk` docker image is consist of the version of `spdk` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[24.09-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/spdk/24.09/24.03-lts-sp1/Dockerfile)| SPDK 24.09 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/spdk` image from docker

	```bash
	docker pull openeuler/spdk:{Tag}
	```

- Run default unit tests:

    By default, if you start the container without specifying a command (such as `bash`), it will automatically run default unit tests.

	```bash
	docker run -it --rm openeuler/spdk:{Tag}
	```
 
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).