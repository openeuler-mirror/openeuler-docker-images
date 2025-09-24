# Quick reference

- The official Grafana docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
- 
# Grafana | openEuler
Current Grafana docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[Grafana open source software](https://grafana.com/oss/) enables you to query, visualize, alert on, and explore your metrics, logs, and traces wherever they are stored. Grafana OSS provides you with tools to turn your time-series database (TSDB) data into insightful graphs and visualizations. The Grafana OSS plugin framework also enables you to connect other data sources like NoSQL/SQL databases, ticketing tools like Jira or ServiceNow, and CI/CD tooling like GitLab.

Learn more on [Grafana website](https://grafana.com/docs/grafana/latest/introduction/).

# Supported tags and respective Dockerfile links
The tag of each grafana docker image is consist of the version of grafana and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[12.2.0-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/grafana/12.2.0/24.03-lts-sp2/Dockerfile) | grafana 12.2.0 on openEuler 24.03-LTS-SP2 | amd64, arm64 |
|[12.1.1-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/grafana/12.1.1/24.03-lts-sp2/Dockerfile) | grafana 12.1.1 on openEuler 24.03-LTS-SP2 | amd64, arm64 |
|[7.5.11-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/grafana/7.5.1/22.03-lts/Dockerfile)| Grafana 7.5.1 on openEuler 22.03-LTS | amd64, arm64 |
|[10.4.1-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/grafana/10.4.1/22.03-lts-sp3/Dockerfile)| Grafana 10.4.1 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[11.1.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/grafana/11.1.0/22.03-lts-sp3/Dockerfile)| Grafana 11.1.0 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[11.2.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/grafana/11.2.0/22.03-lts-sp3/Dockerfile)| Grafana 11.2.0 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[11.2.2-oe2003sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/grafana/11.2.2/20.03-lts-sp4/Dockerfile)| Grafana 11.2.2 on openEuler 20.03-LTS-SP4 | amd64, arm64 |
|[11.2.2-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/grafana/11.2.2/22.03-lts-sp1/Dockerfile)| Grafana 11.2.2 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[11.2.2-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/grafana/11.2.2/22.03-lts-sp3/Dockerfile)| Grafana 11.2.2 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[11.2.2-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/grafana/11.2.2/22.03-lts-sp4/Dockerfile)| Grafana 11.2.2 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[11.2.2-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/grafana/11.2.2/24.03-lts/Dockerfile)| Grafana 11.2.2 on openEuler 24.03-LTS | amd64, arm64 |
|[11.3.0-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/grafana/11.3.0/22.03-lts-sp1/Dockerfile)| Grafana 11.3.0 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[11.3.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/grafana/11.3.0/22.03-lts-sp3/Dockerfile)| Grafana 11.3.0 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[11.3.0-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/grafana/11.3.0/22.03-lts-sp4/Dockerfile)| Grafana 11.3.0 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[11.3.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/grafana/11.3.0/24.03-lts/Dockerfile)| Grafana 11.3.0 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/grafana` image from docker
	```bash
	docker pull openeuler/grafana:{Tag}
	```
- Start a grafana instance

	```bash
	docker run -d --name my-grafana -p 3000:3000 openeuler/grafana:{Tag}
	```
	After the instance `my-grafana` is started, access the kafka service through `http://localhost:3000`.
			
			
- Container startup options
	| Option | Description |
	|--|--|
	| `-p 3000:3000`	 | 	Expose Apache Kafka server on `localhost:3000`. |
    | `-v /path/to/grafana/provisioning/files/:/etc/grafana/provisioning/` | Directory to provision Grafana (see [documentation](https://grafana.com/docs/grafana/latest/administration/provisioning/)⁠). |
    | `-v /path/to/persisted/data:/var/lib/grafana`	| Persist data with a volume instead of initializing a new database for each newly launched container. |

- View container running logs
	```bash
	docker logs -f my-grafana
	```
- To get an interactive shell
	```bash
	docker exec -it my-grafana /bin/bash
	```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).