# Quick reference

- The official Redis docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Redis | openEuler
Current Redis docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Redis is the world’s fastest in-memory database. It provides cloud and on-prem solutions for caching, vector search, and NoSQL databases that seamlessly fit into any tech stack—making it simple for digital customers to build, scale, and deploy the fast apps our world runs on. Learn more on the [Redis website](https://redis.io/about/)⁠.

- License
Starting on March 20th, 2024, Redis follows a dual-licensing model with the choice of the [Redis Source Available License v2 - RSALv2](https://redis.io/legal/rsalv2-agreement/)⁠ or the [Server Side Public License v1 - SSPLv1](https://redis.io/legal/server-side-public-license-sspl/)⁠. Older versions of Redis (<=7.2.4) are licensed under ⁠[3-Clause BSD](https://opensource.org/license/bsd-3-clause).

Please also view the ⁠[Redis License Overview](https://redis.io/legal/licenses/) and the [Redis Trademark Policy](https://redis.io/legal/trademark-policy/)⁠.

- Redis data structures

	- [strings](https://redis.io/docs/latest/develop/data-types/strings/)
	- [hashes](https://redis.io/docs/latest/develop/data-types/hashes/)
	- [lists](https://redis.io/glossary/lists-in-redis/)
	- [sets](https://redis.io/docs/latest/develop/data-types/sets/)
	- [sorted-sets](https://redis.io/docs/latest/develop/data-types/sorted-sets/)
	- [bitmaps](https://redis.io/docs/latest/develop/data-types/bitmaps/)
	- [hyperloglogs](https://redis.io/docs/latest/develop/data-types/probabilistic/hyperloglogs/)
	- [geospatial-indexes](https://redis.io/glossary/geospatial-indexing/)
	- [streams](https://redis.io/docs/latest/develop/data-types/streams/)

- Redis data persistences

	- [dumping the dataset to disk](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/#snapshotting)
	- [appending each command to a disk-based log](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/#append-only-file)

# Supported tags and respective Dockerfile links
The tag of each redis docker image is consist of the version of redis and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[6.2.7-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/redis/6.2.7/22.03-lts/Dockerfile)| Redis 6.2.7 on openEuler 22.03-LTS | amd64, arm64 |
|[7.2.4-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/redis/7.2.4/22.03-lts-sp3/Dockerfile)| Redis 7.2.4 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[7.2.5-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/redis/7.2.5/22.03-lts-sp3/Dockerfile)| Redis 7.2.5 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[7.4.1-oe2003sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/redis/7.4.1/20.03-lts-sp4/Dockerfile)| Redis 7.4.1 on openEuler 20.03-LTS-SP4 | amd64, arm64 |
|[7.4.1-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/redis/7.4.1/22.03-lts-sp1/Dockerfile)| Redis 7.4.1 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[7.4.1-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/redis/7.4.1/22.03-lts-sp3/Dockerfile)| Redis 7.4.1 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[7.4.1-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/redis/7.4.1/22.03-lts-sp4/Dockerfile)| Redis 7.4.1 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[7.4.1-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/redis/7.4.1/24.03-lts/Dockerfile)| Redis 7.4.1 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/redis` image from docker

	```bash
	docker pull openeuler/redis:{Tag}
	```

- Start a redis instance

	```bash
	docker run -d --name my-redis -p 6379:6379 openeuler/redis:{Tag}
	```

- Start with persistent storage

	As follows, this will save a snapshot of the DB every 60 seconds if at least 1 write operation was performed.
	```shell
	docker run --name my-redis -d openeuler/redis:{Tag} redis-server --save 60 1 --loglevel warning
	```

- Connect to a redis instance

	Connect to a local redis instance using loopback address
	```shell
	docker run --name my-redis -d -p 6379:6379 openeuler/redis:{Tag}
	redis-cli -h 127.0.0.1 -p 6379
	```
	If you want connect the redis instance using hostip, you should connect to the instance using loopback,
	and then configure as belows

	```bash
	config set protected-mode no
	```

- Container startup options

	| Option | Description |
	|--|--|
	| `-p 6379:6379`	 | Expose Redis server on `localhost:6379`. |
	| `-e ALLOW_EMPTY_PASSWORD=yes`	 | Set to `yes` to allow connections to redis-server without a password. **This setting is not recommended in production environments**. |
	| `-e REDIS_PASSWORD`	 | Set the desired password to be used. |
	| `-e REDIS_RANDOM_PASSWORD=1` | Set this variable to `1` if you would like the entrypoint script to generate a random password for you. You will be able to see the generated password in the logs (`docker logs`). |
	| `-e REDIS_ALLOW_REMOTE_CONNECTIONS=yes`	 | Set to `no` to disallow remote connections to `redis-server` (i.e., make `redis-server` listen to `127.0.0.1` only). |
	| `-e REDIS_EXTRA_FLAGS`	 | 	Specify extra flags to be passed to `redis-server` when initializing it. |
	| `-v /path/to/redis.conf:/etc/redis/redis.conf`	 | Local [configuration file](https://redis.io/docs/latest/operate/oss_and_stack/management/config/) `redis.conf`. **To enable TLS** mode, comment the `port 6379` line and uncomment the `# port 0` and `# tls-port 6379` lines. |

- View container running logs

	```bash
	docker logs -f my-redis
	```
	
- To get an interactive shell

	```bash
	docker exec -it my-redis /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).