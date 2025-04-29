# Quick reference

- The official Daos(DAOS Storage Stack) docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Daos(DAOS Storage Stack) | openEuler
Current Daos(DAOS Storage Stack) docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

The Distributed Asynchronous Object Storage (DAOS) is an open-source software-defined object store designed from the ground up for massively distributed Non Volatile Memory (NVM). DAOS takes advantage of next generation NVM technology like Storage Class Memory (SCM) and NVM express (NVMe) while presenting a key-value storage interface and providing features such as transactional non-blocking I/O, advanced data protection with self-healing on top of commodity hardware, end-to-end data integrity, fine-grained data control and elastic storage to optimize performance and cost.

Learn more about Daos(DAOS Storage Stack) on [Daos Website](https://docs.daos.io/v2.6/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `daos` docker image is consist of the version of `daos` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[2.3.105-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/daos/2.3.105/22.03-lts-sp1/Dockerfile)| Daos 2.3.105 on openEuler 22.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/daos` image from docker

	```bash
	docker pull openeuler/daos:{Tag}
	```

- Start a daos instance

	```bash
	docker run -d --name my-daos openeuler/daos:{Tag}
	```

- View container running logs

	```bash
	docker logs -f my-daos
	```

- To get an interactive shell

	```bash
	docker run -it --name my-daos openeuler/daos:{Tag} bash
	```
        
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).