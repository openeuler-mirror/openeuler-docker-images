# Quick reference

- The official Loki docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Loki | openEuler
Current Loki docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Loki is a horizontally scalable, highly available, multi-tenant log aggregation system inspired by Prometheus. It is designed to be very cost effective and easy to operate. It does not index the contents of the logs, but rather a set of labels for each log stream.

Learn more on [Loki Website](https://grafana.com/oss/loki/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `loki` docker image is consist of the version of `loki` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[2.9.5-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/loki/2.9.5/22.03-lts-sp3/Dockerfile)| Grafana Loki 2.9.5 on openEuler 22.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/loki` image from docker

	```bash
	docker pull openeuler/loki:{Tag}
	```

- Start a loki instance

	```bash
	docker run -d --name my-loki -p 3100:3100 openeuler/loki:{Tag}
	```
	After the instance `my-loki` is started, access the Loki service through `http://localhost:3100`.

- Container startup options

	| Option | Description |
	|--|--|
	| `-p 3100:3100` | Expose loki on `localhost:8080`. |
	| `-v lokidata:/loki` | 	Persist data in a docker volume named `lokidata`. |
	| `-v /path/to/config/file:/etc/loki/local-config.yaml` | Local configuration file `local-config.yml`. |

- View container running logs

	```bash
	docker logs -f my-loki
	```

- To get an interactive shell

	```bash
	docker exec -it my-loki /bin/bash
	```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).