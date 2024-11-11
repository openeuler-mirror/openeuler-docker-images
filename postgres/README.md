# Quick reference

- The official PostgreSQL docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# PostgreSQL | openEuler
Current PostgreSQL docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

PostgreSQL is a powerful, open source object-relational database system with over 35 years of active development that has earned it a strong reputation for reliability, feature robustness, and performance.

Learn more about PostgreSQL on the [PostgreSQL Website](https://www.postgresql.org/).

# Supported tags and respective Dockerfile links
The tag of each `postgres` docker image is consist of the version of `postgres` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[13.3-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/postgres/13.3/22.03-lts/Dockerfile)| Postgres 13.3 on openEuler 22.03-LTS | amd64, arm64 |
|[16.2-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/postgres/16.2/22.03-lts-sp3/Dockerfile)| Postgres 16.2 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[17.0-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/postgres/17.0/22.03-lts-sp1/Dockerfile)| Postgres 17.0 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[17.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/postgres/17.0/22.03-lts-sp3/Dockerfile)| Postgres 17.0 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[17.0-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/postgres/17.0/22.03-lts-sp4/Dockerfile)| Postgres 17.0 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[17.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/postgres/17.0/24.03-lts/Dockerfile)| Postgres 17.0 on openEuler 24.03-LTS | amd64, arm64 |
  
# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/postgres` image from docker

	```bash
	docker pull openeuler/postgres:{Tag}
	```

- Start a postgres instance

	```bash
	docker run -d --name my-postgres -p 30432:5432 -e POSTGRES_PASSWORD=PostgreSQL@123 openeuler/postgres:{Tag}
	```
	After the instance `my-postgres` is started, access the PostgreSQL  service through `http://localhost:30432`.

- Container startup options

	| Option | Description |
	|--|--|
	| `-p 30432:5432` | Expose PostgreSQL server on `localhost:30432`. |
    | `-e POSTGRES_PASSWORD=passwd` | Set the password for the superuser which is `postgres` by default. Bear in mind that to connect to the database in the same host the password is not needed but to access it via an external host (for instance another container) the password is needed. This option is **mandatory and must not be empty**. |
    | `-e POSTGRES_USER=postgres`  | Create a new user with superuser privileges. This is used in conjunction with `POSTGRES_PASSWORD`. |
    | `-e POSTGRES_INITDB_ARGS="--data-checksums"` | Pass arguments to the `postgres initdb` call. |
    | `-e POSTGRES_DB=postgres` | Set the name of the default database. |
    | `-e POSTGRES_INITDB_WALDIR` | Set the location of the Postgres transaction log. By default it is stored in a subdirectory of the main Postgres data folder (`PGDATA`). |
    | `-e POSTGRES_HOST_AUTH_METHOD=trust` | Set the auth-method for `host` connections for `all` databases, `all` users, and `all` addresses. The following will be added to the `pg_hba.conf` if this option is passed: `host all all all $POSTGRES_HOST_AUTH_METHOD`. |
    | `-e PGDATA=/path/to/location` | Set the location of the database files. The default is `/var/lib/postgresql/data`. |
    | `-v /path/to/postgresql.conf:/etc/postgresql/postgresql.conf` | Local configuration file `postgresql.conf`. |
    | `-v /path/to/persisted/data:/var/lib/postgresql/data` | Persist data instead of initializing a new database every time you launch a new container. |

- View container running logs

	```bash
	docker logs -f my-postgres
	```

- To get an interactive shell

	```bash
	docker exec -it my-postgres /bin/bash
	```
	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).