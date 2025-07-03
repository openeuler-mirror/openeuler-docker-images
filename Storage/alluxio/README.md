# Quick reference

- The official alluxio docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# alluxio(alluxio Storage Stack) | openEuler
Current alluxio(alluxio Storage Stack) docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Alluxio Open Source (formerly known as Tachyon) is a Distributed Caching Platform for large-scale data. It bridges the gap between computation frameworks and storage systems, enabling computation applications to connect to numerous storage systems through a common interface.

Learn more about alluxio, please visit [https://www.alluxio.io/](https://www.alluxio.io/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `alluxio` docker image is consist of the version of `alluxio` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[2.9.4-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/alluxio/2.9.4/24.03-lts-sp1/Dockerfile)| Alluxio 2.9.4 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage

- Create a network for connecting Alluxio containers
	```
	docker network create alluxio_nw
	```

- Create a volume for storing ufs data
	```
	docker volume create ufs
	```

- Launch the Alluxio master
	```
	docker run -d --net=alluxio_nw \
		-p 19999:19999 \
		--name=alluxio-master \
		-v ufs:/opt/alluxio/underFSStorage \
		openeuler/alluxio:latest master
	```
	You can access `alluxio-master` at: `http://localhost:19999`
        
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).