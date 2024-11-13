# Quick reference

- The official Prometheus-pushgateway docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Prometheus-pushgateway | openEuler
Current Prometheus-pushgateway docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

The Pushgateway is an intermediary service which allows you to push metrics from jobs which cannot be scraped. For details, see [Pushing metrics](https://prometheus.io/docs/instrumenting/pushing/).

Learn more about Prometheus-pushgateway on the [Prometheus-pushgateway Website](https://prometheus.io/docs/practices/pushing/).

# Supported tags and respective Dockerfile links
The tag of each `prometheus-pushgateway` docker image is consist of the version of `prometheus-pushgateway` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.7.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/prometheus-pushgateway/1.7.0/22.03-lts-sp3/Dockerfile)| Prometheus-pushgateway 1.7.0 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[1.10.0-oe2003sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/prometheus-pushgateway/1.10.0/20.03-lts-sp4/Dockerfile)| Prometheus-pushgateway 1.10.0 on openEuler 20.03-LTS-SP4 | amd64, arm64 |
|[1.10.0-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/prometheus-pushgateway/1.10.0/22.03-lts-sp1/Dockerfile)| Prometheus-pushgateway 1.10.0 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[1.10.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/prometheus-pushgateway/1.10.0/22.03-lts-sp3/Dockerfile)| Prometheus-pushgateway 1.10.0 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[1.10.0-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/prometheus-pushgateway/1.10.0/22.03-lts-sp4/Dockerfile)| Prometheus-pushgateway 1.10.0 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[1.10.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/prometheus-pushgateway/1.10.0/24.03-lts/Dockerfile)| Prometheus-pushgateway 1.10.0 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/prometheus-pushgateway` image from docker

	```bash
	docker pull openeuler/prometheus-pushgateway:{Tag}
	```
	
- Start a prometheus-pushgateway instance

	```bash
	docker run -d --name my-prometheus-pushgateway -p 9091:9091 openeuler/prometheus-pushgateway:{Tag}
	```
	After the instance `my-prometheus-pushgateway` is started, access the Prometheus-pushgateway service through `http://localhost:9091`.

- Container startup options

	| Option | Description |
	|--|--|
	| `-p 9091:9091` | Expose Prometheus-pushgateway server on `localhost:9091`. |

- View container running logs

	```bash
	docker logs -f my-prometheus-pushgateway
	```

- To get an interactive shell

	```bash
	docker exec -it my-prometheus-pushgateway /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).