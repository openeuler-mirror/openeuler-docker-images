# Quick reference

- The official Alertmanager docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Alertmanager | openEuler
Current Alertmanager docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

The Alertmanager handles alerts sent by client applications (such as a Prometheus server). It is responsible for deduplication, grouping, and routing them to the correct sink integration, such as email, PagerDuty, OpsGenie, or many other mechanisms with the help of a webhook receiver. It is also responsible for silencing and suppressing alerts. Read more on the [official documentation⁠](https://prometheus.io/docs/alerting/latest/alertmanager/).

# Supported tags and respective Dockerfile links
The tag of each `alertmanager` docker image is consist of the version of `alertmanager` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[0.27.0-oe2003sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/alertmanager/0.27.0/20.03-lts-sp4/Dockerfile)| Alertmanager 0.27.0 on openEuler 20.03-LTS-SP4 | amd64, arm64 |
|[0.27.0-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/alertmanager/0.27.0/22.03-lts-sp1/Dockerfile)| Alertmanager 0.27.0 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[0.27.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/alertmanager/0.27.0/22.03-lts-sp3/Dockerfile)| Alertmanager 0.27.0 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[0.27.0-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/alertmanager/0.27.0/22.03-lts-sp4/Dockerfile)| Alertmanager 0.27.0 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[0.27.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/alertmanager/0.27.0/24.03-lts/Dockerfile)| Alertmanager 0.27.0 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/alertmanager` image from docker

	```bash
	docker pull openeuler/alertmanager:{Tag}
	```

- Start a alertmaanger instance

	```bash
	docker run -d --name my-alertmanager -p 9093:9093 openeuler/alertmanager:{Tag}
	```
	After the instance `my-alertmanager` is started, access the alertmanager service through `http://localhost:9093`.

- Container startup options

	| Option | Description |
	|--|--|
	| `-p 9093:9093` | Expose alertmanager on `localhost:9093`. |
	| `-v /local/path/to/website:/var/www/html` | Mount and serve a local website. |
	| `-v /path/to/alertmanager.yml:/etc/prometheus/alertmanager.yml`	| Local configuration file alertmanager.yml. |
	| `-v /path/to/persisted/data:/alertmaanger` | Persist data instead of initializing a new database for each newly launched container. |

- View container running logs

	```bash
	docker logs -f my-alertmaanger
	```

- To get an interactive shell

	```bash
	docker exec -it my-alertmaanger /bin/bash
	```
	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).