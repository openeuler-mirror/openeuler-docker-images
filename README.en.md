[中文](README.md) | English

# openEuler official container images

## Introduction

Dockerfiles for openEuler official container images, include openEuler basic image and application images.


## Basic Container Image

openEuler basic image is published by openEuler community in [openEuler repo](https://repo.openeuler.org), "openeuler:latest" is the current stable available image.

After the official images are published, we will push to the third-party Hubs, details are as follows:

- name: `openeuler/openeuler`
- Download: `docker pull [Remote repo URL]openeuler/openeuler[:tags]`
- Support arch: amd64, arm64
- Tags:
    - [20.03-lts](https://repo.openeuler.org/openEuler-20.03-LTS/docker_img/)
	- [20.03-lts-sp1](https://repo.openeuler.org/openEuler-20.03-LTS-SP1/docker_img/)
	- [20.03-lts-sp2](https://repo.openeuler.org/openEuler-20.03-LTS-SP2/docker_img/)
	- [20.03-lts-sp3](https://repo.openeuler.org/openEuler-20.03-LTS-SP3/docker_img/)
	- [20.03-lts-sp4, 20.03](https://repo.openeuler.org/openEuler-20.03-LTS-SP4/docker_img/)
	- [20.09](https://archives.openeuler.openatom.cn/openEuler-20.09/docker_img/)
	- [21.03](https://archives.openeuler.openatom.cn/openEuler-21.03/docker_img/)
	- [21.09](https://archives.openeuler.openatom.cn/openEuler-21.09/docker_img/)
	- [22.03-lts](https://repo.openeuler.org/openEuler-22.03-LTS/docker_img/)
	- [22.09](https://archives.openeuler.openatom.cn/openEuler-22.09/docker_img/)
	- [22.03-lts-sp1](https://repo.openeuler.org/openEuler-22.03-LTS-SP1/docker_img/)
	- [22.03-lts-sp2](https://repo.openeuler.org/openEuler-22.03-LTS-SP2/docker_img/)
	- [22.03-lts-sp3](https://repo.openeuler.org/openEuler-22.03-LTS-SP3/docker_img/)
	- [22.03-lts-sp4, 22.03](https://repo.openeuler.org/openEuler-22.03-LTS-SP4/docker_img/)
	- [23.03](https://repo.openeuler.org/openEuler-23.03/docker_img/)
	- [23.09](https://repo.openeuler.org/openEuler-23.09/docker_img/)
	- [24.03-lts, latest](https://repo.openeuler.org/openEuler-24.03-LTS/docker_img/)
- Path rule：`openeuler/Dockerfile`

## Application Container Image

Dockerfiles for various popular application implementations based on openEuler basic image.

- Repository rule：`openeuler/[Application name]`, such as: `openeuler/nginx`.
- Path rule：`[Application name]/[Application version]/[openEuler version]/Dockerfile`, such as: the nginx 1.20.1 based on openEuler 20.03 LTS SP1 is under `nginx/1.20.1/20.03-lts-sp1/Dockerfile`.

	In particular, for application container images of complex software stacks, in order to accurately express their dependencies, the `[application version]` in the Dockerfile storage path can be described as the complete software stack version, for example: `pytorch/2.1.0-cann7 .0.RC1.alpha002/22.03-lts-sp2/Dockerfile` stores the pytorch 2.1.0 application image Dockerfile based on cann7.0.RC1.alpha002 and openEuler 22.03-lts-sp2.
- Tag rule: `[Application version]-[openEuler version]`, such as: `openeuler/nginx:1.20.1-oe2003sp1`.

The contents of each application container image directory:

1. All openEuler application images contain a README (such as nginx/README.md), included:
	- `Quick reference`：related links
	- `[Application name] | openEuler`：application descriptions
	- `Supported tags and respective Dockerfile links`：tags and Dockerfile links, this must be updated when a new tag is published
	- `Usage`：describe how to use the application container image, and try to give a test case that can be easily run
	- `Question and answering`：where to file bugs and issues

	The README will be synchronously published to the third-party Hubs, so please be serious while contributing.

2. All openEuler application images contain a `meta.yml` file，which stores the image tag info，the file path is: `[app-name]/meta.yml`. The example is as follows：

 	- `meta.yml`

			# spark/meta.yml
			3.3.1-oe2203lts:
	  			path: spark/3.3.1/22.03-lts/Dockerfile
			3.3.2-oe2203lts:
			 	path: spark/3.3.2/22.03-lts/Dockerfile
		 	
	In the above example, each pair of `<key, value>` contains image's publishing configuration, it's as follows:
	- key: Tag of the image,  `3.3.1-oe2203lts` and `3.3.2-oe2203lts` are different image tags of the openeuler/spark.
	- value: It contains configuration items those are used to build image, thos are follows.
	
		Configuration description:
		| Item | Optional | Description | Example |
		|--|--|--|--|
		| path | yes | Relative path of the image dockerfile | spark/3.3.1/22.03-lts/Dockerfile |
		| arch | no |  This configuration is required when only one architecture is supported. By default, it supports arm64 and amd64 architectures.| x86_64，only x86_64 or aarch64 can be configured. |
	
	It is required to add or update the meta.yml while Dockerfile is changed.

3. All openEuler application images contain a `doc/` directory, which stores the graphic and text information of the image:

	- `doc/image-info.yml`

		The content is as follows:

			name
			category (such as: bigdata, ai, storage, database, cloud, hpc, others)
			description
			environment
			tags
			download
			usage
			license
			similar_packages
			dependency

	- `doc/picture/`

		Store application-related images, such as application logos or runtime screenshots of typical scenes.


## Available Container Registries

Available container registries included:
1. [hub.oepkgs.net](https://hub.oepkgs.net/)
2. [hub.docker.com](https://hub.docker.com/)
3. [quay.io](https://quay.io/)

For example, users can obtain the base image `openeuler/openeuler:latest` by the following commands
```
# pull image from hub.oepkgs.net
docker pull hub.oepkgs.net/openeuler/openeuler:latest

# pull image from hub.docker.com
docker pull docker.io/openeuler/openeuler:latest

# pull from quay.io
docker pull quay.io/openeuler/openeuler:latest
```

## Contributions

Welcome to contribute openEuler application container images, please submit PR according to the above rules. As the PR is passed and merged, the automatically publishing process will be triggered, and these images will be published to available container registries mentioned above!

Code check instruction:
1. [EulerPublisher](https://gitee.com/openeuler/eulerpublisher) is used to build, check and publish container images.
2. All test cases of application container images are stored in [/tests/container/app](https://gitee.com/openeuler/eulerpublisher/tree/master/tests/container/app). Developers who want to publish container images can also submit test cases to [EulerPublisher](https://gitee.com/openeuler/eulerpublisher).
3. When the PR in which you add or modify a Dockerfile is merged, a new image will be automatically published or the existing image will be updated.
4. When the PR in which you add or modify a README.md is merged, the README.md will be synchronously published to the third-party Hubs.
