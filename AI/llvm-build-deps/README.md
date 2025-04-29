# Quick reference

- The official llvm-build-deps docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# llvm-build-deps | openEuler
Current llvm-build-deps docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

These docker images are built to ensure environment compatibility when building [llvm-project](https://gitee.com/openeuler/llvm-project) in openEuler. 

# Supported tags and respective Dockerfile links
The tag of each llvm-build-deps docker image is consist of the version of llvm-build-deps and the version of basic image. The details are as follows

| Tags | Currently |  Architectures|
|------|-----------|---------------|
|[1.0.0-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/llvm-build-deps/1.0.0/22.03-lts-sp4/Dockerfile)| llvm-build-deps 1.0.0 on openEuler 22.03-LTS | amd64, arm64 |


# Usage
Here, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/llvm-build-deps` image from `hub.docker.com`

	```bash
	docker pull openeuler/llvm-build-deps:{Tag}
	```

- Start a `llvm-build-deps` instance

	```bash
	docker run -it --name my-llvm-build-deps openeuler/llvm-build-deps:{Tag}
	```
# Operating System
Linux/Unix, ARM64 or X86-64 architecture.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
