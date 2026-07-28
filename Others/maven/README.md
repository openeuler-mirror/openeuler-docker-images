# Quick reference

- The official Apache Maven docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Apache Maven | openEuler
Current Apache Maven docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Maven is a software project management and comprehension tool. Based on the concept of a project object model (POM), Maven can manage a project's build, reporting and documentation from a central piece of information.

Learn more on [Apache Maven website](https://maven.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each `maven` docker image is consist of the version of `maven` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
| [3.6.3-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/maven/3.6.3/24.03-lts-sp1/Dockerfile) | Apache Maven 3.6.3 on openEuler 24.03-LTS-SP1 | amd64, arm64 |
| [3.6.3-oe2403sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/maven/3.6.3/24.03-lts-sp4/Dockerfile) | Apache Maven 3.6.3 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/maven` image from docker

	```bash
	docker pull openeuler/maven:{Tag}
	```

- Start a maven instance to build a project

	```bash
	docker run -it --rm -v "$PWD":/usr/src/mymaven -w /usr/src/mymaven openeuler/maven:{Tag} mvn clean install
	```
