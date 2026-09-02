# Quick reference

- The official Percona Server docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Percona Server | openEuler
Current Percona Server docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Percona Server for MySQL is a free, fully compatible, enhanced, and open source drop-in replacement for MySQL, providing superior performance, scalability, and instrumentation.

Learn more on [Percona Server website](https://www.percona.com/software/mysql-database/percona-server).

# Supported tags and respective Dockerfile links
The tag of each `percona` docker image is consist of the version of `percona` and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[8.4.10-10-oe2403sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/percona/8.4.10-10/24.03-lts-sp4/Dockerfile) | Percona Server 8.4.10-10 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/percona` image from docker

	```bash
	docker pull openeuler/percona:{Tag}
	```
	
- Start a Percona Server instance

	```bash
	docker run -d --name my-percona -p 3306:3306 -e MYSQL_ROOT_PASSWORD=openEuler:S3cr3t/ openeuler/percona:{Tag}
	```
	After the instance `my-percona` is started, access the Percona Server service through `http://localhost:3306`.
	
- Container startup options
	| Option | Description |
	|--|--|
	| `-p 3306:3306`	 | 	Expose Percona Server on `localhost:3306`. |
    | `-e MYSQL_ROOT_PASSWORD` | 	Set the password for the `root` user. This option is **mandatory** and **must not be empty**. |
    | `-e MYSQL_USER`	| 	Create a new user with superuser privileges. This is used in conjunction with `MYSQL_PASSWORD`. |
    | `-e MYSQL_DATABASE` | Set the name of the default database. |
    | `-e MYSQL_ALLOW_EMPTY_PASSWORD=yes` | 	Set up a blank password for the root user. **This is not recommended to be used in production, make sure you know what you are doing**. |
    | `-e MYSQL_RANDOM_ROOT_PASSWORD=yes` | Generate a random initial password for the `root` user. It will be printed in the logs, search for `GENERATED ROOT PASSWORD`. |
    | `-e MYSQL_ONETIME_PASSWORD=yes` | Set `root` user as expired once initialization is complete, forcing a password change on first login. |
    | `-v /path/to/data:/usr/local/percona/data/` | 	Persist data instead of initializing a new database every time you launch a new container. |
	
- View container running logs

	```bash
	docker logs -f my-percona
	```

- To get an interactive shell

	```bash
	docker exec -it my-percona /bin/bash
	```
	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).