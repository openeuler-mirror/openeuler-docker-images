# Quick reference

- The official etcd docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Etcd | openEuler
Current etcd docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Etcd is a distributed key-value store designed to securely store data across a cluster. etcd is widely used in production on account of its reliability, fault-tolerance and ease of use.

Learn more about etcd at [https://etcd.io/](https://etcd.io/).

# Supported tags and respective Dockerfile links
The tag of each `etcd` docker image is consist of the version of `etcd` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[3.6.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/etcd/3.6.0/24.03-lts-sp1/Dockerfile)| Etcd 3.6.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage

- Create a network

	```bash
	docker network create app-tier --driver bridge
	```

- Launch the Etcd server instance

	Use the `--network app-tier` argument to the `docker run` command to attach the Etcd container to the `app-tier` network.
	```
	docker run -d --name Etcd-server \
		--network app-tier \
		--publish 2379:2379 \
		--publish 2380:2380 \
		--env ALLOW_NONE_AUTHENTICATION=yes \
		--env ETCD_ADVERTISE_CLIENT_URLS=http://etcd-server:2379 \
		openeuler/etcd:latest
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).