# Quick reference

- The official StarRocks docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# StarRocks | openEuler
Current StarRocks docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

StarRocks is the world's fastest open query engine for sub-second, ad-hoc analytics both on and off the data lakehouse. It features a native vectorized SQL engine, supports ANSI SQL syntax and MySQL protocol, and enables real-time updates with concurrent queries. A Linux Foundation project, StarRocks eliminates the need for denormalization and adapts to your use cases without moving data or rewriting SQL. Learn more on the [StarRocks Website](https://starrocks.io).

# Supported tags and respective Dockerfile links
The tag of each `starrocks` docker image is consist of the version of `starrocks` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
| [4.1.1-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Cloud/starrocks/4.1.1/24.03-lts-sp3/Dockerfile) | StarRocks 4.1.1 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/starrocks` image from docker

	docker pull openeuler/starrocks:{Tag}

- Start a StarRocks FE instance

	docker run -d --name my-starrocks-fe -p 8030:8030 -p 9030:9030 openeuler/starrocks:{Tag}
	After the instance `my-starrocks-fe` is started, access the StarRocks query service through `mysql -h 127.0.0.1 -P9030 -uroot`.

- Start a StarRocks BE instance

	docker run -d --name my-starrocks-be -p 8040:8040 openeuler/starrocks:{Tag} /opt/starrocks/be/bin/start_be.sh --daemon

- Container startup options

	| Option | Description |
	|--------|-------------|
	| `-p 8030:8030` | Expose FE HTTP service on `localhost:8030`. |
	| `-p 9030:9030` | Expose FE MySQL query port on `localhost:9030`. |
	| `-p 8040:8040` | Expose BE HTTP service on `localhost:8040`. |
	| `-v /path/to/fe.conf:/opt/starrocks/fe/conf/fe.conf` | Mount custom FE configuration file. |
	| `-v /path/to/be.conf:/opt/starrocks/be/conf/be.conf` | Mount custom BE configuration file. |
	| `-v /path/to/meta:/opt/starrocks/fe/meta` | Persist FE metadata. |
	| `-v /path/to/data:/opt/starrocks/be/storage` | Persist BE storage data. |

- View container running logs

	docker logs -f my-starrocks-fe

- To get an interactive shell

	docker exec -it my-starrocks-fe /bin/bash

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
