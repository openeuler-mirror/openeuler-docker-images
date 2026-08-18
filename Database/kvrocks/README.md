# Quick reference

- The official Apache Kvrocks docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# Kvrocks | openEuler
Current kvrocks docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Kvrocks is a distributed key value NoSQL database that uses RocksDB as storage engine and is compatible with Redis protocol. Kvrocks intends to decrease the cost of memory and increase the capacity while compared to Redis. The design of replication and storage was inspired by [rocksplicator](https://github.com/pinterest/rocksplicator) and [blackwidow](https://github.com/Qihoo360/blackwidow).

Learn more on [Apache Kvrocks™ | Apache Kvrocks™](https://kvrocks.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each `kvrocks` docker image is consist of the version of `kvrocks` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[2.16.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Database/kvrocks/2.16.0/24.03-lts-sp4/Dockerfile) | kvrocks 2.16.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/kvrocks` image from docker

	```bash
	docker pull openeuler/kvrocks:{Tag}
	```

- Run the kvrocks instance

	```bash
	docker run -d --name my-kvrocks -p 6666:6666 openeuler/kvrocks:{Tag}
	```

- Run with persistent storage

	As follows, this will create a docker volume and start a kvrocks container with the volume mounted on the data directory.
	```bash
	docker volume create kvrocks_data
	docker run -d --name my-kvrocks -p 6666:6666 --volume kvrocks_data:/var/lib/kvrocks openeuler/kvrocks:{Tag}
	```

- Connect to the kvrocks instance

	```bash
	redis-cli -p 6666
	```

- View container running logs

	```bash
	docker logs -f my-kvrocks
	```

- To get an interactive shell

	```bash
	docker exec -it my-kvrocks /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
