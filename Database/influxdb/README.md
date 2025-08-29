# Quick reference

- The official influxdb docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# influxdb | openEuler
Current influxdb docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

InfluxDB Core is a database built to collect, process, transform, and store event and time series data. It is ideal for use cases that require real-time ingest and fast query response times to build user interfaces, monitoring, and automation solutions.

Learn more about influxdb at [https://influxdb.io/](https://influxdb.io/).

# Supported tags and respective Dockerfile links
The tag of each `influxdb` docker image is consist of the version of `influxdb` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[3.4.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/influxdb/3.4.1/24.03-lts-sp1/Dockerfile) | influxdb 3.4.1 on openEuler 24.03-LTS-SP1 | amd64, arm64 |
|[3.4.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/influxdb/3.4.0/24.03-lts-sp1/Dockerfile) | influxdb 3.4.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |
|[2.7.11-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/influxdb/2.7.11/24.03-lts-sp1/Dockerfile)| Influxdb 2.7.11 on openEuler 24.03-LTS-SP1 | amd64, arm64 |
|[3.3.0-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/influxdb/3.3.0/24.03-lts-sp2/Dockerfile)| Influxdb 3.3.0 on openEuler 24.03-LTS-SP2 | amd64, arm64 |

# Usage

- Launch the influxdb instance

	```
	docker run -it -p 8086:8086 openeuler/influxdb:latest
	```
	The following message indicates that the influxdb is ready
	```
	2025-07-02T02:07:01.507857Z	info	Listening	{"log_id": "0xUE2JM0000", "service": "tcp-listener", "transport": "http", "addr": ":8086", "port": 8086}
	2025-07-02T02:07:01.507881Z	info	Starting	{"log_id": "0xUE2JM0000", "service": "telemetry", "interval": "8h"}
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).