# Quick reference

- The official Prometheus docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Prometheus | openEuler
Current Prometheus docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Prometheus is an open-source systems monitoring and alerting toolkit originally built at SoundCloud. Since its inception in 2012, many companies and organizations have adopted Prometheus, and the project has a very active developer and user community. It is now a standalone open source project and maintained independently of any company. To emphasize this, and to clarify the project's governance structure, Prometheus joined the Cloud Native Computing Foundation in 2016 as the second hosted project, after Kubernetes.

Learn more about Prometheus on the [Prometheus Website](https://prometheus.io/docs/introduction/overview/).

# Supported tags and respective Dockerfile links
The tag of each `prometheus` docker image is consist of the version of `prometheus` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
 |[2.20.0-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/prometheus/2.20.0/22.03-lts/Dockerfile)| Prometheus server 2.20.0 on openEuler 22.03-LTS | amd64, arm64 |
  |[2.50.1-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/prometheus/2.50.1/22.03-lts-sp3/Dockerfile)| Prometheus server 2.50.1 on openEuler 22.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/prometheus` image from docker
	```bash
	docker pull openeuler/prometheus:{Tag}
	```

- Start a prometheus instance

	```bash
	docker run -d --name my-prometheus -p 9090:9090 openeuler/prometheus:{Tag}
	```
	After the instance `my-prometheus` is started, access the Prometheus service through `http://localhost:9090`.

- Container startup options

	| Option | Description |
	|--|--|
	| `-p 9090:9090` | Expose Prometheus server on `localhost:9090`. |
    | `-v /path/to/prometheus.yml:/etc/prometheus/prometheus.yml` | Local configuration file `prometheus.yml`. |
    | `-v /path/to/alerts.yml:/etc/prometheus/alerts.yml` | Local alerts configuration file `alerts.yml`. |

- View container running logs

	```bash
	docker logs -f my-prometheus
	```

- To get an interactive shell

	```bash
	docker exec -it my-prometheus /bin/bash
	```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).