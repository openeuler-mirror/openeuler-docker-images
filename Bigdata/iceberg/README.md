# Quick reference

- The official Iceberg docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# Iceberg | openEuler
Current Iceberg docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Iceberg is a high-performance format for huge analytic tables. Iceberg brings the reliability and simplicity of SQL tables to big data, while making it possible for engines like Spark, Trino, Flink, Presto, Hive, and Impala to safely work with the same tables, at the same time.

Learn more on [Iceberg website](https://iceberg.apache.org/).


# Supported tags and respective Dockerfile links
The tag of each iceberg docker image is consist of the version of iceberg and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.10.1-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Bigdata/iceberg/1.10.1/24.03-lts-sp3/Dockerfile) | Apache Iceberg 1.10.1 on openEuler 24.03-LTS-SP3 | amd64, arm64 |


# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/iceberg` image from docker
	```bash
	docker pull openeuler/iceberg:{Tag}
	```
- Start an iceberg container in interactive mode

	```bash
	docker run -it --name my-iceberg openeuler/iceberg:{Tag}
	```
	This starts an interactive shell inside the container. The Iceberg source code and compiled JARs are located at `/opt/iceberg`, ready to use out of the box — no JDK, Gradle, or dependency setup required.

- Container startup options
	| Option | Description |
	|--|--|
	| `-v /path/to/project:/workspace`	 | 	Mount a local project directory into the container. |
    | `-v /path/to/config:/opt/iceberg/conf` | Local Iceberg configuration directory. |
    | `-v icebergData:/var/lib/iceberg` | Persist data in a docker volume named `icebergData`. |

- View container running logs
	```bash
	docker logs -f my-iceberg
	```
- To get an interactive shell
	```bash
	docker exec -it my-iceberg /bin/bash
	```

- Develop Iceberg itself — modify the source and rebuild inside the container:
	```bash
	docker exec -it my-iceberg bash
	cd /opt/iceberg
	# ... make changes ...
	./gradlew build -x test -x integrationTest
	```

- Build derived images — use this image as a base to stack Spark, Flink, or Trino on top. The pre-built Iceberg JARs at `/opt/iceberg` are ready to be referenced by connector classpaths, so you don't rebuild Iceberg from scratch:
	```dockerfile
	FROM openeuler/iceberg:1.10.1-oe2403sp3
	RUN yum install -y ... && wget https://.../spark-3.5.0.tgz ...
	```

- Develop Iceberg-based applications — write Java or Scala programs that depend on the compiled Iceberg JARs:
	```bash
	docker exec -it my-iceberg bash
	javac -cp "/opt/iceberg/core/build/libs/*" MyIcebergApp.java
	java -cp ".:/opt/iceberg/core/build/libs/*" MyIcebergApp
	```

- Learn and benchmark — read the source, step through code with a debugger, or run the built-in benchmarks for performance comparisons between Iceberg versions.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
