# Quick reference

- The official Kafka docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# Kafka | openEuler
Current Kafka docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Kafka is an open-source distributed event streaming platform used by thousands of companies for high-performance data pipelines, streaming analytics, data integration, and mission-critical applications.

Learn more on [Kafka website](https://kafka.apache.org/).


# Supported tags and respective Dockerfile links
The tag of each kafka docker image is consist of the version of kafka and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[3.7.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/kafka/3.7.0/22.03-lts-sp3/Dockerfile)| Apache Kafka server 3.7.0 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[3.8.0-oe2003sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/kafka/3.8.0/20.03-lts-sp4/Dockerfile)| Apache Kafka server 3.8.0 on openEuler 20.03-LTS-SP4 | amd64, arm64 |
|[3.8.0-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/kafka/3.8.0/22.03-lts-sp1/Dockerfile)| Apache Kafka server 3.8.0 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[3.8.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/kafka/3.8.0/22.03-lts-sp3/Dockerfile)| Apache Kafka server 3.8.0 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[3.8.0-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/kafka/3.8.0/22.03-lts-sp4/Dockerfile)| Apache Kafka server 3.8.0 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[3.8.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/kafka/3.8.0/24.03-lts/Dockerfile)| Apache Kafka server 3.8.0 on openEuler 24.03-LTS | amd64, arm64 |
|[3.8.1-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/kafka/3.8.1/22.03-lts-sp1/Dockerfile)| Apache Kafka server 3.8.1 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[3.8.1-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/kafka/3.8.1/22.03-lts-sp3/Dockerfile)| Apache Kafka server 3.8.1 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[3.8.1-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/kafka/3.8.1/22.03-lts-sp4/Dockerfile)| Apache Kafka server 3.8.1 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[3.8.1-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/kafka/3.8.1/24.03-lts/Dockerfile)| Apache Kafka server 3.8.1 on openEuler 24.03-LTS | amd64, arm64 |
|[3.9.0-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/kafka/3.9.0/22.03-lts-sp1/Dockerfile)| Apache Kafka server 3.9.0 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[3.9.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/kafka/3.9.0/22.03-lts-sp3/Dockerfile)| Apache Kafka server 3.9.0 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[3.9.0-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/kafka/3.9.0/22.03-lts-sp4/Dockerfile)| Apache Kafka server 3.9.0 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[3.9.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/kafka/3.9.0/24.03-lts/Dockerfile)| Apache Kafka server 3.9.0 on openEuler 24.03-LTS | amd64, arm64 |


# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/kafka` image from docker
	```bash
	docker pull openeuler/kafka:{Tag}
	```
- Start a kafka instance

	```bash
	docker run -d --name my-kafka -p 9092:9092 openeuler/kafka:{Tag}
	```
	After the instance `my-kafka` is started, access the kafka service through `http://localhost:9092`.

- Container startup options
	| Option | Description |
	|--|--|
	| `-p 9092:9092`	 | 	Expose Apache Kafka server on `localhost:9092`. |
    | `-e ZOOKEEPER_HOST=<zookeeper>` | Hostname for the related Zookeeper instance. |
    | `-e ZOOKEEPER_PORT=2181`	| 	Port for the related Zookeeper instance. |
    | `-v /path/to/config/file:/etc/kafka/server.properties` | Local Kafka configuration file. |
    | `-v kafkaData:/var/lib/kafka` | "Persist data in a docker volume named `kafkaData`. " "Make sure that the mount point is consistent with the configuration property `logs.dirs`. |

- View container running logs
	```bash
	docker logs -f my-kafka
	```
- To get an interactive shell
	```bash
	docker exec -it my-kafka /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).