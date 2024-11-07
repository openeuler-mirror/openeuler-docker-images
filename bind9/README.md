# Quick reference

- The official BIND9 (Berkeley Internet Name Domain 9） docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# BIND9 (Berkeley Internet Name Domain 9） | openEuler
Current BIND9 (Berkeley Internet Name Domain 9） docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

BIND9 (Berkeley Internet Name Domain 9) is an open source Domain Name System (DNS) software used to convert domain names into corresponding IP addresses, including authoritative servers, recursive resolvers, and related utilities.

Read more on the [BIND 9 website](https://www.isc.org/bind/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `bind9` docker image is consist of the version of `bind9` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[9.18.24-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/bind9/9.18.24/22.03-lts-sp3/Dockerfile)| Bind9 9.18.24 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[9.21.2-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/bind9/9.21.2/22.03-lts-sp1/Dockerfile)| Bind9 9.21.2 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[9.21.2-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/bind9/9.21.2/22.03-lts-sp3/Dockerfile)| Bind9 9.21.2 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[9.21.2-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/bind9/9.21.2/22.03-lts-sp4/Dockerfile)| Bind9 9.21.2 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[9.21.2-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/bind9/9.21.2/24.03-lts/Dockerfile)| Bind9 9.21.2 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/bind9` image from docker

	```bash
	docker pull openeuler/bind9:{Tag}
	```

- Start a bind9 instance

	```bash
	docker run -d --name my-bind9 -p 30053:53 openeuler/bind9:{Tag}
	```
	After the instance `my-bind9` is started, access the bind9 service through `http://localhost:30053`.

- Container startup options

	| Option | Description |
	|--|--|
	| `-p 30053:53` | Expose bind9 on `localhost:30053`. |
	| `-v /path/to/bind/configuration:/etc/named.conf` | Local configuration file ⁠named.conf. |

- View container running logs

	```bash
	docker logs -f my-bind9
	```

- To get an interactive shell

	```bash
	docker exec -it my-bind9 /bin/bash
	```
	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).