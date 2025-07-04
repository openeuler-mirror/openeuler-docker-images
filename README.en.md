[中文](README.md) | English

# openEuler Official Container Images

## Introduction

Dockerfiles for openEuler official container images, include openEuler basic image and application images.

## Related Links
- [openEuler Container Image Usage Guide](https://forum.openeuler.org/t/topic/4189)
- [Bisheng JDK Container Image Practice](https://blog.csdn.net/weixin_43878094/article/details/139444574)

## Base Images

The base images of openEuler are officially released by the community and are currently available at [openEuler repo](https://repo.openeuler.org). The `latest` tag represents the latest available long-term stable image.

Once the official images are released, they will be synchronized and pushed to various remote container image repositories, as detailed below:

### 1. Repository and Image Name
The {repository/name} for the base image on third-party image hubs is `openeuler/openeuler`

### 2. Supported Tags
- [24.03-lts-sp2, 24.03, latest](https://repo.openeuler.org/openEuler-24.03-LTS-SP1/docker_img/)
- [25.03](https://repo.openeuler.org/openEuler-25.03/docker_img/)
- [24.03-lts-sp1](https://repo.openeuler.org/openEuler-24.03-LTS-SP1/docker_img/)
- [24.03-lts](https://repo.openeuler.org/openEuler-24.03-LTS/docker_img/)
- [22.03-lts-sp4, 22.03](https://repo.openeuler.org/openEuler-22.03-LTS-SP4/docker_img/)
- [22.03-lts-sp3](https://repo.openeuler.org/openEuler-22.03-LTS-SP3/docker_img/)
- [22.03-lts-sp2](https://repo.openeuler.org/openEuler-22.03-LTS-SP2/docker_img/)
- [22.03-lts-sp1](https://repo.openeuler.org/openEuler-22.03-LTS-SP1/docker_img/)
- [22.03-lts](https://repo.openeuler.org/openEuler-22.03-LTS/docker_img/)
- [24.09](https://repo.openeuler.org/openEuler-24.09/docker_img/)
- [23.09](https://repo.openeuler.org/openEuler-23.09/docker_img/)
- [23.03](https://repo.openeuler.org/openEuler-23.03/docker_img/)
- [22.09](https://archives.openeuler.openatom.cn/openEuler-22.09/docker_img/)
- [20.03-lts-sp4, 20.03](https://repo.openeuler.org/openEuler-20.03-LTS-SP4/docker_img/)
- [20.03-lts-sp3](https://repo.openeuler.org/openEuler-20.03-LTS-SP3/docker_img/)
- [20.03-lts-sp2](https://repo.openeuler.org/openEuler-20.03-LTS-SP2/docker_img/)
- [20.03-lts-sp1](https://repo.openeuler.org/openEuler-20.03-LTS-SP1/docker_img/)
- [20.03-lts](https://repo.openeuler.org/openEuler-20.03-LTS/docker_img/)
- [21.09](https://archives.openeuler.openatom.cn/openEuler-21.09/docker_img/)
- [21.03](https://archives.openeuler.openatom.cn/openEuler-21.03/docker_img/)
- [20.09](https://archives.openeuler.openatom.cn/openEuler-20.09/docker_img/)

### 3. Contents
`Base/openeuler/Dockerfile`

## Application Images

Images for various popular application implementations based on openEuler base images.


### 1. Repository and Image Name
The {repository/name} for the application images on third-party image hubs is `openeuler/[application name]`

### 2. Contents
Application images are categorized into seven types based on scenarios, and the image building files are stored in corresponding scenario directories:
  - Bigdata:    `Bigdata/`
  - AI:       `AI/`
  - Distributed Storage: `Storage/`
  - Database:    `Database/`
  - Cloud Service:    `Cloud/`
  - Distroless: `Distroless/`
  - High-Performance Computing: `HPC/`
  - Others:      `Others/`


#### 2.1 Overall Directory
Due to the complexity of application image functionalities, the depth of the directory is uncertain. The overall directory is as follows:
```
openeuler-docker-images/
└── AI/
    |── image-list.yml
	|── OPEA/
	|    |── AudioQnA/
	|	 |    └── Image_1/
	|	 |    └── Image_2/
	|	 └── DocSum/
	|	      └── Image_3/
	|	      └── Image_4/
	|		  └── Image_5/
	|───Image6/
	└───Image7/
```
Each scenario directory must contain an `image-list.yml` to describe the roots for each application image's **minimum directory unit (MDU)** (i.e., all `Image_i/`s in the example), `image-list.yml` is formatted as follows:
```
# AI/image-list.yml
images:
	Image_1: AI/OPEA/AudioQnA/Image_1/  # root path to Image_1
	Image_2: AI/OPEA/AudioQnA/Image_2/
	Image_3: AI/OPEA/DocSum/Image_3/
	Image_4: AI/OPEA/DocSum/Image_4/
	Image_5: AI/OPEA/DocSum/Image_5/
	Image_6: Image_6/
	Image_7: Image_7/
```
The existence of `image-list.yml`:
- Helps check the integrity of the image directory.
- Facilitates the listing of application images in [openEuler Software Center](https://easysoftware.openeuler.org/zh/image).

### 2.2 Minimum Directory
This repository requires the **minimum directory unit** `Image_i/` to strictly follow the structure below:
```
# here, Image_i == nginx
nginx/
	|── README.md
	|── meta.yml
	|── doc/ (optional)
	|    |── picture/
	|	 |    └── logo.png
	|	 └── image-info.yml
	└── 1.27.2/
	     |── 24.03-lts
		 |    └── Dockerfile
		 |── 22.03-lts-sp4
		 |    └── Dockerfile
	     |── 22.03-lts-sp3
		 |    └── Dockerfile
	     └── 22.03-lts-sp1
		      └── Dockerfile
```
In each **MDU** `Image_i/`, the following contents must be included:
- Dockerfile

	The storage path is `[application version]/[openEuler version]/Dockerfile`. For example, the Dockerfile for the nginx application image version `1.27.1` based on openEuler `22.03-lts-sp1` is located at `1.27.1/22.03-lts-sp1/Dockerfile`.

	Specifically, for complex software stack application container images, to accurately express their dependencies, the application version in the Dockerfile storage path can be described as the complete software stack version number. For example, in PyTorch root path: `2.1.0-cann7.0.RC1.alpha002/22.03-lts-sp2/Dockerfile` stores the Dockerfile for the pytorch `2.1.0` version application image based on `cann7.0.RC1.alpha002` and openEuler `22.03-lts-sp2` (AI container image tags can refer to [oEEP-0014](https://gitee.com/openeuler/TC/blob/be62b1cb6d5131aafac5f7b0eabf75d712d2b4f0/oEEP/oEEP-0014%20openEuler%20AI%E5%AE%B9%E5%99%A8%E9%95%9C%E5%83%8F%E8%BD%AF%E4%BB%B6%E6%A0%88%E8%A7%84%E8%8C%83.md)).


- README.md

	The README should cover the following information in order:

    - Quick reference: Relevant link information
    - [Application Name] | openEuler: Description of the application's functionality
    - Supported tags and respective Dockerfile links: Description of the current application container image tags and Dockerfile links; must be updated when new images are added
    - Usage: Description of how to use the application container image, ideally including a simple runnable test case
    - Question and answering: Provide Issue links
 	
	The README will be published to the Overview or Description section of the third-party Hub image detail page; contributions via PR should be taken seriously.

- meta.yml

	This file describes the tag information and Dockerfile storage paths for each image, located at: `[application name]/meta.yml`. The file format is as follows:
	```
	# spark/meta.yml
	3.3.1-oe2203lts: 
		path: spark/3.3.1/22.03-lts/Dockerfile
	3.3.2-oe2203lts:
		path: spark/3.3.2/22.03-lts/Dockerfile
		arch: aarch64
	``` 	
	In the above example, each pair of `<key, value>` contains image's publishing configuration, it's as follows:
	- key: Represents the image tag, with a recommended naming format of: `[application version]-[openeuler version]`, such as `3.3.1-oe2203lts` and `3.3.2-oe2203lts`, indicating different tags of the `openeuler/spark`.
	- value: Describes how to build the image, explained as follows:
	
		Configuration description:
		| Configuration Item | Required | Description | Example |
		|--|--|--|--|
		| path | yes | Relative path of the image dockerfile | spark/3.3.1/22.03-lts/Dockerfile |
		| arch | optional |  Specifies the architecture when releasing a single-architecture image, optional `x86_64` or `aarch64` <br> if not filled, a dual-architecture image for both `x86_64` and `aarch64` will be released by default | x86_64 |
	
	*Note: **When updating the image tag, the above configuration must also be updated**.

- (Optional) `doc/`

	This directory stores graphic and textual information about the image for display in [openEuler Software Center](https://easysoftware.openeuler.org/zh/image)'s application image section. If it is not to be displayed in [openEuler Software Center](https://easysoftware.openeuler.org/zh/image), this section can be omitted.

	- `doc/image-info.yml`

		The content is as follows:

			name
			category (options: bigdata, ai, storage, database, cloud, hpc, others)
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
	
	*Note: **The files and contents in the above `doc/` directory must exist simultaneously for the image to be displayed correctly in [openEuler Software Center](https://easysoftware.openeuler.org/zh/image)**.

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

Welcome to contribute openEuler application container images, please submit PR according to the above rules. Once the PR is passed and merged, the automatically publishing process will be triggered, and these images will be published to available container registries mentioned above!

Code check instruction:
1. [EulerPublisher](https://gitee.com/openeuler/eulerpublisher) is used to build, check and publish container images.
2. All test cases of application container images are stored in [/tests/container/app](https://gitee.com/openeuler/eulerpublisher/tree/master/tests/container/app). Developers who want to publish container images can also submit test cases to [EulerPublisher](https://gitee.com/openeuler/eulerpublisher).
3. When the PR in which you add or modify a Dockerfile is merged, a new image will be automatically published or the existing image will be updated.
4. When the PR in which you add or modify a README.md is merged, the README.md will be synchronously published to the third-party Hubs.
5. **Published images generally cannot be removed**, even if they are no longer updated or maintained, as users may still be using them. Therefore, in special cases where an image needs to be removed, please create an issue providing the tag of the image to be removed and the reason for removal, and contact the maintainer.