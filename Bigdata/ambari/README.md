# Quick reference

- The official Ambari docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# Ambari | openEuler
Current Ambari docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Ambari is a tool for provisioning, managing, and monitoring Apache Hadoop clusters. It provides a RESTful API and a browser-based management UI that simplifies cluster configuration, management, and monitoring.

Learn more on [Ambari website](https://ambari.apache.org/).


# Supported tags and respective Dockerfile links
The tag of each ambari docker image is consist of the version of ambari and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[3.0.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Bigdata/ambari/3.0.0/24.03-lts-sp3/Dockerfile) | Apache Ambari 3.0.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |


# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/ambari` image from docker
	```bash
	docker pull openeuler/ambari:{Tag}
	```
- Start an ambari server instance

	```bash
	docker run -d --name my-ambari -p 8080:8080 openeuler/ambari:{Tag}
	```
	After the instance `my-ambari` is started, access the Ambari Web UI at `http://localhost:8080`. The default login is `admin` / `admin`.

- Container startup options
	| Option | Description |
	|--|--|
	| `-p 8080:8080`	 | 	Expose Ambari Web UI and REST API on `localhost:8080`. |
    | `-v /path/to/config:/etc/ambari-server/conf` | Local Ambari Server configuration directory. |

- View container running logs
	```bash
	docker logs -f my-ambari
	```
- To get an interactive shell
	```bash
	docker exec -it my-ambari /bin/bash
	```
- Setup Ambari Server (database initialization, run once before first start)
	```bash
	docker exec -it my-ambari python3 ambari-server/src/main/python/ambari-server.py setup -s
	```

- Build Ambari derived images — use this image as a base to include pre-configured Hadoop stack components. The compiled Ambari artifacts at `/opt/ambari` are ready to use.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
