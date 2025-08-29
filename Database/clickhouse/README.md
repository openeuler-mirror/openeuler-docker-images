# Quick reference

- The official clickhouse docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Clickhouse | openEuler
Current clickhouse docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

ClickHouse is an open-source column-oriented database management system that allows generating analytical data reports in real-time.

Learn more about clickhouse at [https://clickhouse.com/](https://clickhouse.com/).

# Supported tags and respective Dockerfile links
The tag of each `clickhouse` docker image is consist of the version of `clickhouse` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[25.3.1.2703-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/clickhouse/25.3.1.2703/24.03-lts-sp1/Dockerfile)| Clickhouse 25.3.1.2703 on openEuler 24.03-LTS-SP1 | amd64, arm64 |
|[25.7.5.34-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/clickhouse/25.7.5.34/24.03-lts-sp2/Dockerfile)| Clickhouse 25.7.5.34 on openEuler 24.03-LTS-SP2 | amd64, arm64 |

# Usage

- Start server instance

	```bash
	docker run -d --name my-clickhouse-server --ulimit nofile=262144:262144 openeuler/clickhouse:latest
	```
	By default, ClickHouse will be accessible only via the Docker network. See the networking section below.

	By default, starting above server instance will be run as the `default` user without password.

- Connect to it from a native client
	```
	docker run -it --rm --network=container:my-clickhouse-server --entrypoint clickhouse-client clickhouse
	# OR
	docker exec -it my-clickhouse-server clickhouse-client
	```
	More information about the [ClickHouse client](https://clickhouse.com/docs/interfaces/cli/)

- Connect to it using curl

	```bash
	echo "SELECT 'Hello, ClickHouse!'" | docker run -i --rm --network=container:my-clickhouse-server buildpack-deps:curl curl 'http://localhost:8123/?query=' -s --data-binary @-
	```

- Stop the container

	```bash
	docker stop my-clickhouse-server
	docker rm my-clickhouse-server
	```
	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).