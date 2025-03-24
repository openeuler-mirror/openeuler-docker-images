# Quick reference

- The official Grafana-agent docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# Grafana-agent | openEuler
Current Grafana-agent docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Grafana Agent is an OpenTelemetry Collector distribution with configuration inspired by [Terraform](https://www.terraform.io/). It is designed to be flexible, performant, and compatible with multiple ecosystems such as Prometheus and OpenTelemetry.

Grafana Agent is based around **components**. Components are wired together to form programmable observability **pipelines** for telemetry collection, processing, and delivery.

Grafana Agent can collect, transform, and send data to:

- The [Prometheus](https://prometheus.io/) ecosystem
- The [OpenTelemetry](https://opentelemetry.io/) ecosystem
- The Grafana open source ecosystem ([Loki](https://github.com/grafana/loki), [Grafana](https://github.com/grafana/grafana), [Tempo](https://github.com/grafana/tempo), [Mimir](https://github.com/grafana/mimir), [Pyroscope](https://github.com/grafana/pyroscope))

Learn more on [Grafana-agent website](https://grafana.com/docs/agent/latest/).

# Supported tags and respective Dockerfile links
The tag of each grafana-agent docker image is consist of the version of grafana-agent and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[0.40.2-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/grafana-agent/0.40.2/22.03-lts-sp3/Dockerfile)| Grafana-agent 0.40.2 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[0.41.1-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/grafana-agent/0.41.1/22.03-lts-sp3/Dockerfile)| Grafana-agent 0.41.1 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[0.43.3-oe2003sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/grafana-agent/0.43.3/20.03-lts-sp4/Dockerfile)| Grafana-agent 0.43.3 on openEuler 20.03-LTS-SP4 | amd64, arm64 |
|[0.43.3-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/grafana-agent/0.43.3/22.03-lts-sp1/Dockerfile)| Grafana-agent 0.43.3 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[0.43.3-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/grafana-agent/0.43.3/22.03-lts-sp3/Dockerfile)| Grafana-agent 0.43.3 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[0.43.3-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/grafana-agent/0.43.3/22.03-lts-sp4/Dockerfile)| Grafana-agent 0.43.3 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[0.43.3-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/grafana-agent/0.43.3/24.03-lts/Dockerfile)| Grafana-agent 0.43.3 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/grafana-agent` image from docker
	```bash
	docker pull openeuler/grafana-agent:{Tag}
	```
- Start a grafana-agent instance

	```bash
	docker run -d --name my-grafana-agent -p 12345:12345 openeuler/grafana-agent:{Tag}
	```
	After the instance `my-grafana-agent` is started, access the grafana-agent service through `http://localhost:12345`.
			
			
- Container startup options
	| Option | Description |
	|--|--|
	| `-p 12345:12345`	 | 	Expose Grafana Agent on `localhost:12345`. |
    | `-v /path/to/agent/config.yaml:/etc/agent/agent.yaml` | Local configuration file `agent.yml`. |

- View container running logs
	```bash
	docker logs -f my-grafana-agent
	```
- To get an interactive shell
	```bash
	docker exec -it my-grafana-agent /bin/bash
	```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).