# Quick reference

- The official OpenJDK docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# OpenJDK | openEuler
Current OpenJDK docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

The place to collaborate on an open-source implementation of the Java Platform, Standard Edition, and related projects.

Learn more about OpenJDK on the [https://openjdk.org/).

# Supported tags and respective Dockerfile links
The tag of each `openjdk` docker image is consist of the version of `openjdk` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[23_13-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/openjdk/23+13/22.03-lts-sp3/Dockerfile)| OpenJDK 23+13 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
  
# Usage
In this usage, users can select the corresponding `{Tag}`  based on their requirements.

- Pull the `openeuler/openjdk` image from docker

	```bash
	docker pull openeuler/openjdk:{Tag}
	```

- Start a openjdk instance

	```bash
	docker run -it --name my-openjdk openeuler/openjdk:{Tag}
	```

- View container running logs

	```bash
	docker logs -f my-openjdk
	```

- To get an interactive shell

	```bash
	docker exec -it my-openjdk /bin/bash
	```
	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).