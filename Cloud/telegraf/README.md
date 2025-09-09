# Quick reference

- The official Telegraf docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Telegraf | openEuler
Current Telegraf docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Telegraf, a server-based agent, collects and sends metrics and events from databases, systems, and IoT sensors. Written in Go, Telegraf compiles into a single binary with no external dependencies–requiring very minimal memory.

Learn more on [Telegraf website](https://docs.influxdata.com/telegraf/v1/).

# Supported tags and respective Dockerfile links
The tag of each `telegraf` docker image is consist of the version of `telegraf` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.36.1-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.36.1/24.03-lts-sp2/Dockerfile) | telegraf 1.36.1 on openEuler 24.03-LTS-SP2 | amd64, arm64 |
|[1.35.4-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.35.4/24.03-lts-sp1/Dockerfile) | telegraf 1.35.4 on openEuler 24.03-LTS-SP1 | amd64, arm64 |
|[1.29.5-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.29.5/22.03-lts-sp3/Dockerfile)| Telegraf 1.29.5 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[1.31.1-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.31.1/22.03-lts-sp3/Dockerfile)| Telegraf 1.31.1 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[1.32.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.32.0/22.03-lts-sp3/Dockerfile)| Telegraf 1.32.0 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[1.32.1-oe2003sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.32.1/20.03-lts-sp4/Dockerfile)| Telegraf 1.32.1 on openEuler 20.03-LTS-SP4 | amd64, arm64 |
|[1.32.1-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.32.1/22.03-lts-sp1/Dockerfile)| Telegraf 1.32.1 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[1.32.1-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.32.1/22.03-lts-sp3/Dockerfile)| Telegraf 1.32.1 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[1.32.1-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.32.1/22.03-lts-sp4/Dockerfile)| Telegraf 1.32.1 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[1.32.1-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.32.1/24.03-lts/Dockerfile)| Telegraf 1.32.1 on openEuler 24.03-LTS | amd64, arm64 |
|[1.32.2-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.32.2/22.03-lts-sp1/Dockerfile)| Telegraf 1.32.2 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[1.32.2-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.32.2/22.03-lts-sp3/Dockerfile)| Telegraf 1.32.2 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[1.32.2-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.32.2/22.03-lts-sp4/Dockerfile)| Telegraf 1.32.2 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[1.32.2-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.32.2/24.03-lts/Dockerfile)| Telegraf 1.32.2 on openEuler 24.03-LTS | amd64, arm64 |


# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/telegraf` image from docker

	```bash
	docker pull openeuler/telegraf:{Tag}
	```

- Start a telegraf instance

	```bash
	docker run -d --name my-telegraf -p 8094:8094 -v /path/to/telegraf.conf:/etc/telegraf/telegraf.conf openeuler/telegraf:{Tag}
	```
	After the instance `my-telegraf` is started, access the Telegraf service through `http://localhost:8094`.

- Container startup options

	| Option | Description |
	|--|--|
	| `-p 8094:8094` | Expose telegraf on `localhost:8094`. |
	| `-v /path/to/telegraf.conf:/etc/telegraf/telegraf.conf` | Local [configuration file](https://docs.influxdata.com/telegraf/v1/)⁠ `telegraf.conf`. |

- View container running logs

	```bash
	docker logs -f my-telegraf
	```

- To get an interactive shell

	```bash
	docker exec -it my-telegraf /bin/bash
	```
	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).