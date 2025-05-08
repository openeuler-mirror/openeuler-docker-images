# Quick reference

- The official WildFly docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# WildFly | openEuler
Current WildFly docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

WildFly is a powerful, modular, & lightweight application server that helps you build amazing enterprise Java applications.

Learn more on [WildFly Website](https://wildfly.org)⁠.

# Supported tags and respective Dockerfile links
The tag of each `wildfly` docker image is consist of the version of `wildfly` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[36.0.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/wildfly/36.0.0/24.03-lts-sp1/Dockerfile)| WildFly 36.0.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/wildfly` image from docker

	```bash
	docker pull openeuler/wildfly:{Tag}
	```

- To boot in standalone mode

	```bash
	docker run -d -p 8080:8080 --name my-wildfly openeuler/wildfly:{TAG}
	```

- To boot in domain mode

	```bash
	docker run -d  --name my-wildfly openeuler/wildfly:{TAG} ./bin/domain.sh -b 0.0.0.0 -bmanagement 0.0.0.0
	```

- View container running logs

	```bash
	docker logs -f my-wildfly
	```

- To get an interactive shell

	```bash
	docker exec -it my-wildfly /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).