# Quick reference

- The official Cassandra docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Cassandra | openEuler
Current Cassandra docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Cassandra is a free and open-source database management system designed to handle large volumes of data across multiple commodity servers. Cassandra supports clusters and spanning of multiple data centers, featuring asynchronous and masterless replication. It enables low-latency operations for all clients and incorporates Amazon's Dynamo distributed storage and replication techniques, combined with Google's Bigtable data storage engine model.

Learn more about Cassandra at [https://cassandra.apache.org/](https://cassandra.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each `cassandra` docker image is consist of the version of `cassandra` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[4.1.4-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/cassandra/4.1.1/22.03-lts-sp3/Dockerfile)| Cassandra 4.1.4 on openEuler 22.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/cassandra` image from docker

	```bash
	docker pull openeuler/cassandra:{Tag}
	```

- Start a cassandra instance

	```bash
	docker run -d --name my-cassandra -p 7000:7000 -p 7001:7001 -p 7199:7199 -p 9042:9042 -p 9160:9160 openeuler/cassandra:{Tag}
	```
	After the instance `my-cassandra` is started, access the alertmanager service through `cqlsh localhost 9042`(Install cqlsh using `pip install cqlsh`).

- Container startup options

	| Option | Description |
    |--|--|
    | -p 7000:7000 | Exposes the port used for inter-node communication. |
    | -p 7001:7001 | Exposes the port used for inter-node TLS encrypted communication. |
    | -p 7199:7199 | Exposes the JMX management port. |
    | -p 9042:9042 | Exposes the CQL interaction port. |
    | -p 9160:9160 | Exposes the Thrift service port. |
    | -v /local/path/to/data:/var/lib/cassandra	| Location to store data. |
    | -v /path/to/logs:/var/log/cassandra | Location to store logs.  |

- View container running logs

	```bash
	docker logs -f my-cassandra
	```

- To get an interactive shell

	```bash
	docker exec -it my-cassandra /bin/bash
	```
	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).