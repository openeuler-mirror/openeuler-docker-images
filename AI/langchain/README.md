# Quick reference

- The official LangChain docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# LangChain | openEuler
Current LangChain docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

# Supported tags and respective Dockerfile links
The tag of each langchain docker image is consist of the version of langchain and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[0.3.23-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/langchain/0.3.23/22.03-lts-sp4/Dockerfile)| langchain 0.3.23 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[0.3.23-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/langchain/0.3.23/24.03-lts-sp1/Dockerfile)| langchain 0.3.23 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage

In this usage, users can select the corresponding `{Tag}`  based on their requirements.

- Pull the `openeuler/langchain` image from docker

	```bash
	docker pull openeuler/langchain:{Tag}
	```

- Start a langchain instance

	```bash
	docker run -d --name my-langchain openeuler/langchain:{Tag}
	```

- View container running logs

	```bash
	docker logs -f my-langchain
	```

- To get an interactive shell

	```bash
	docker exec -it my-langchain /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
