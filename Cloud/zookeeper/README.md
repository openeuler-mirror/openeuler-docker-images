# Quick reference

- The official Zookeeper docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Zookeeper | openEuler
Current Zookeeper docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

ZooKeeper is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services. All of these kinds of services are used in some form or another by distributed applications. Each time they are implemented there is a lot of work that goes into fixing the bugs and race conditions that are inevitable. Because of the difficulty of implementing these kinds of services, applications initially usually skimp on them, which make them brittle in the presence of change and difficult to manage. Even when done correctly, different implementations of these services lead to management complexity when the applications are deployed.

Learn more about ZooKeeper on the [ZooKeeper Wiki](https://cwiki.apache.org/confluence/display/ZOOKEEPER/Index).

# Supported tags and respective Dockerfile links
The tag of each `zookeeper` docker image is consist of the version of `zookeeper` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[3.8.3-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/zookeeper/3.8.3/22.03-lts-sp3/Dockerfile)| zookeeper 3.8.3 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[3.9.2-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/zookeeper/3.9.2/22.03-lts-sp3/Dockerfile)| zookeeper 3.9.2 on openEuler 22.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/zookeeper` image from docker

	```bash
	docker pull openeuler/zookeeper:{Tag}
	```

- Start a zookeeper instance

	```bash
	docker run -d --name my-zookeeper -p 2181:2181 openeuler/zookeeper:{Tag}
	```
	After the instance `my-zookeeper` is started, access the Zookeeper service through `http://localhost:2181`.

- Container startup options

	| Option | Description |
	|--|--|
	| `-p 2181:2181` | Expose ZooKeeper server on `localhost:2181`. |
    | `-v /path/to/config/file:/etc/zookeeper/zoo.cfg` | Local ZooKeeper configuration file. |
    | `-v zookeeperData:/var/lib/zookeeper/data` | Persist data in a docker volume named `zookeeperData`. Make sure that the mount point is consistent with the configuration property `dataDir`. |
    | `-v zookeeperLogData:/var/lib/zookeeper/data-log` | Persist data in a docker volume named `zookeeperLogData`. Make sure that the mount point is consistent with the configuration property `dataLogDir`. |

- View container running logs

	```bash
	docker logs -f my-zookeeper
	```

- To get an interactive shell

	```bash
	docker exec -it my-zookeeper /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).