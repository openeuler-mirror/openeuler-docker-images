# Quick reference

- The official mariadb docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# mariadb | openEuler
Current mariadb docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

MariaDB server is a community developed fork of MySQL server. Started by core members of the original MySQL team, MariaDB actively works with outside developers to deliver the most featureful, stable, and sanely licensed open SQL server in the industry.

Learn more about mariadb at [https://mariadb.org/](https://mariadb.org/).

# Supported tags and respective Dockerfile links
The tag of each `mariadb` docker image is consist of the version of `mariadb` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[11.7.2-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/mariadb/11.7.2/24.03-lts-sp1/Dockerfile)| mariadb 11.7.2 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage

- Launch the mariadb instance

	As applications talk to MariaDB, MariaDB needs to start in the same network as the application:	
	```
	docker network create some-network 
	docker run --detach --network some-network --name some-mariadb --env MARIADB_USER=example-user --env MARIADB_PASSWORD=my_cool_secret --env MARIADB_ROOT_PASSWORD=my-secret-pw openeuler/mariadb:latest
	```
	You can connect to MariaDB from the MariaDB command line client, more information about the MariaDB command-line client can be found in the [MariaDB Command Line Client⁠](https://mariadb.com/kb/en/mariadb-command-line-client/)

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).