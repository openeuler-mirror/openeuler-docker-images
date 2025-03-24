# Quick reference

- The official Grafana Mimir docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Grafana Mimir | openEuler
Current Grafana Mimir docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Grafana Mimir is an open source software project that provides a scalable long-term storage for Prometheus. Some of the core strengths of Grafana Mimir include:

* Easy to install and maintain: Grafana Mimir’s extensive documentation, tutorials, and deployment tooling make it quick to get started. Using its monolithic mode, you can get Grafana Mimir up and running with just one binary and no additional dependencies. Once deployed, the best-practice dashboards, alerts, and runbooks packaged with Grafana Mimir make it easy to monitor the health of the system.
* Massive scalability: You can run Grafana Mimir’s horizontally-scalable architecture across multiple machines, resulting in the ability to process orders of magnitude more time series than a single Prometheus instance. Internal testing shows that Grafana Mimir handles up to 1 billion active time series.
* Global view of metrics: Grafana Mimir enables you to run queries that aggregate series from multiple Prometheus instances, giving you a global view of your systems. Its query engine extensively parallelizes query execution, so that even the highest-cardinality queries complete with blazing speed.
* Cheap, durable metric storage: Grafana Mimir uses object storage for long-term data storage, allowing it to take advantage of this ubiquitous, cost-effective, high-durability technology. It is compatible with multiple object store implementations, including AWS S3, Google Cloud Storage, Azure Blob Storage, OpenStack Swift, as well as any S3-compatible object storage.
* High availability: Grafana Mimir replicates incoming metrics, ensuring that no data is lost in the event of machine failure. Its horizontally scalable architecture also means that it can be restarted, upgraded, or downgraded with zero downtime, which means no interruptions to metrics ingestion or querying.
* Natively multi-tenant: Grafana Mimir’s multi-tenant architecture enables you to isolate data and queries from independent teams or business units, making it possible for these groups to share the same cluster. Advanced limits and quality-of-service controls ensure that capacity is shared fairly among tenants.

Learn more about Grafana Mimir on the [https://grafana.com/docs/mimir/latest/).

# Supported tags and respective Dockerfile links
The tag of each `mimir` docker image is consist of the version of `mimir` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[2.11.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/mimir/2.11.0/22.03-lts-sp3/Dockerfile)| Grafana mimir 2.11.0 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[2.13.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/mimir/2.13.0/22.03-lts-sp3/Dockerfile)| Grafana mimir 2.13.0 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[2.14.0-oe2003sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/mimir/2.14.0/20.03-lts-sp4/Dockerfile)| Grafana mimir 2.14.0 on openEuler 20.03-LTS-SP4 | amd64, arm64 |
|[2.14.0-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/mimir/2.14.0/22.03-lts-sp1/Dockerfile)| Grafana mimir 2.14.0 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[2.14.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/mimir/2.14.0/22.03-lts-sp3/Dockerfile)| Grafana mimir 2.14.0 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[2.14.0-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/mimir/2.14.0/22.03-lts-sp4/Dockerfile)| Grafana mimir 2.14.0 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[2.14.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/mimir/2.14.0/24.03-lts/Dockerfile)| Grafana mimir 2.14.0 on openEuler 24.03-LTS | amd64, arm64 |
|[2.14.1-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/mimir/2.14.1/22.03-lts-sp1/Dockerfile)| Grafana mimir 2.14.1 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[2.14.1-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/mimir/2.14.1/22.03-lts-sp3/Dockerfile)| Grafana mimir 2.14.1 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[2.14.1-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/mimir/2.14.1/22.03-lts-sp4/Dockerfile)| Grafana mimir 2.14.1 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[2.14.1-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/mimir/2.14.1/24.03-lts/Dockerfile)| Grafana mimir 2.14.1 on openEuler 24.03-LTS | amd64, arm64 |
  
# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/mimir` image from docker

	```bash
	docker pull openeuler/mimir:{Tag}
	```

- Start a mimir instance

	```bash
	docker run -d --name my-mimir -p 8080:8080 openeuler/mimir:{Tag}
	```
	After the instance `my-mimir` is started, access the Grafana Mimir service through `http://localhost:8080`.

- Container startup options

	| Option | Description |
	|--|--|
	| `-p 8080:8080` | Expose Mimir server on `localhost:8080`. |

- View container running logs

	```bash
	docker logs -f my-mimir
	```

- To get an interactive shell

	```bash
	docker exec -it my-mimir /bin/bash
	```
	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).