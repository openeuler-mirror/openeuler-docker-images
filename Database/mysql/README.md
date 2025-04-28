# Quick reference

- The official MySQL docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# MySQL | openEuler
Current MySQL docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Learn more on [MySQL website]().

# Supported tags and respective Dockerfile links
The tag of each mysql docker image is consist of the version of mysql and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[8.3.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/mysql/8.3.0/22.03-lts-sp3/Dockerfile)| MySQL server 8.3.0 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[9.1.0-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/mysql/9.1.0/22.03-lts-sp1/Dockerfile)| MySQL server 9.1.0 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[9.1.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/mysql/9.1.0/22.03-lts-sp3/Dockerfile)| MySQL server 9.1.0 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[9.1.0-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/mysql/9.1.0/22.03-lts-sp4/Dockerfile)| MySQL server 9.1.0 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[9.1.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/mysql/9.1.0/24.03-lts/Dockerfile)| MySQL server 9.1.0 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/mysql` image from docker

	```bash
	docker pull openeuler/mysql:{Tag}
	```
	
- Start a mysql instance

	```bash
	docker run -d --name my-mysql -p 30306:3306 -e MYSQL_ROOT_PASSWORD=openEuler:S3cr3t/ openeuler/mysql:{Tag}
	```
	After the instance `my-mysql` is started, access the mysql service through `http://localhost:30306`.
	
- Container startup options
	| Option | Description |
	|--|--|
	| `-p 30306:3306`	 | 	Expose MySQL server on `localhost:30306`. |
    | `-e MYSQL_ROOT_PASSWORD` | 	Set the password for the `root` user. This option is **mandatory** and **must not be empty**. |
    | `-e MYSQL_USER`	| 	Create a new user with superuser privileges. This is used in conjunction with `MYSQL_PASSWORD`. |
    | `-e MYSQL_DATABASE` | Set the name of the default database. |
    | `-e MYSQL_ALLOW_EMPTY_PASSWORD=yes` | 	Set up a blank password for the root user. **This is not recommended to be used in production, make sure you know what you are doing**. |
    | `-e MYSQL_RANDOM_ROOT_PASSWORD=yes` | Generate a random initial password for the `root` user using `pwgen`. It will be printed in the logs, search for `GENERATED ROOT PASSWORD`. |
    | `-e MYSQL_ONETIME_PASSWORD=yes` | Set `root` user as experide once initialization is complete, forcing a password change on first login. |
    | `-v /path/to/data:/usr/local/mysql/data/` | 	Persist data instead of initializing a new database every time you launch a new container. |
    | `-v /path/to/config/files/:/usr/local/mysql/mysql.conf.d/` | Local [configuration files](https://dev.mysql.com/doc/refman/8.0/en/mysql-command-options.html). |
	
- View container running logs

	```bash
	docker logs -f my-mysql
	```

- To get an interactive shell

	```bash
	docker exec -it my-mysql/bin/bash
	```
	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).