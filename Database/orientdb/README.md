# Quick reference

- The official orientdb docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# orientdb | openEuler
Current orientdb docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

OrientDB is the most versatile DBMS supporting Graph, Document, Reactive, Full-Text and Geospatial models in one Multi-Model product. OrientDB can run distributed (Multi-Master), supports SQL, ACID Transactions, Full-Text indexing and Reactive Queries.

For more information about orientdb, please visit [https://orientdb.dev/](https://orientdb.dev/).

# Supported tags and respective Dockerfile links
The tag of each orientdb docker image is consist of the version of orientdb and the version of basic image. The details are as follows

| Tags                                                                                                                                  | Currently                                  | Architectures |
|---------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------|---------------|
| [3.2.44-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/orientdb/3.2.44/24.03-lts-sp2/Dockerfile) | OrientDB 3.2.44 on openEuler 24.03-LTS-SP2 | amd64, arm64  |
| [3.2.44-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/orientdb/3.2.44/24.03-lts-sp1/Dockerfile) | OrientDB 3.2.44 on openEuler 24.03-LTS-SP1 | amd64, arm64  |
| [3.2.43-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/orientdb/3.2.43/24.03-lts-sp1/Dockerfile)  | OrientDB 3.2.43 on openEuler 24.03-LTS-SP1 | amd64, arm64  |
| [3.2.38-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/orientdb/3.2.38/24.03-lts-sp1/Dockerfile)  | OrientDB 3.2.38 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage

This image is used to verify if the upstream orientdb version can be integrated with openEuler, users should sutup orientdb by themselves.

- Pull the `openeuler/orientdb` image from docker

	```bash
	docker pull openeuler/orientdb:{Tag}
	```
	
- Start an orientdb instance

	```bash
	docker run -d --name my-orientdb -p 2480:2480 -e ORIENTDB_ROOT_PASSWORD=openEuler:S3cr3t/ openeuler/orientdb:{Tag}
	```
	After the instance `my-orientdb` is started, access the orientdb service through `http://{host_ip}:2480/studio/index.html`.

- Container startup options

	| Option                                      | Description                                                                                    |
	|---------------------------------------------|------------------------------------------------------------------------------------------------|
	| `-p 2480:2480`	                             | 	Expose OrientDB server on `localhost:2480`.                                                   |
    | `-e ORIENTDB_ROOT_PASSWORD`                 | 	Set the password for the `root` user. This option is **mandatory** and **must not be empty**. |
    | `-v /path/to/backup:/orientdb/backup`       | 	This directory is where OrientDB stores `database backup files`.                              |
    | `-v /path/to/databases:/orientdb/databases` | 	This is the main `data storage directory` for OrientDB.                                       |
    | `-v /path/to/config:/orientdb/config`       | This directory contains the `configuration files` (e.g., orientdb-server-config.xml, etc.).    |
	

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).