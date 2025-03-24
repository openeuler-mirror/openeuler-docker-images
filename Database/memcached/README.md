# Quick reference

- The official Memcached docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Memcached | openEuler
Current Memcached docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Memcached is an in-memory key-value store for small chunks of arbitrary data (strings, objects) from results of database calls, API calls, or page rendering. Free & open source, high-performance, distributed memory object caching system, generic in nature, but intended for use in speeding up dynamic web applications by alleviating database load. Memcached is simple yet powerful. Its simple design promotes quick deployment, ease of development, and solves many problems facing large data caches. Its API is available for most popular languages.

Learn more about Memcached on the [https://memcached.org/).

# Supported tags and respective Dockerfile links
The tag of each `memcached` docker image is consist of the version of `memcached` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.6.12-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/memcached/1.6.12/22.03-lts-sp3/Dockerfile)| Memcached 1.6.12 on openEuler 22.03-LTS | amd64, arm64 |
|[1.6.24-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/memcached/1.6.24/22.03-lts-sp3/Dockerfile)| Memcached 1.6.24 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[1.6.29-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/memcached/1.6.29/22.03-lts-sp3/Dockerfile)| Memcached 1.6.29 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[1.6.31-oe2003sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/memcached/1.6.31/20.03-lts-sp4/Dockerfile)| Memcached 1.6.31 on openEuler 20.03-LTS-SP4 | amd64, arm64 |
|[1.6.31-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/memcached/1.6.31/22.03-lts-sp1/Dockerfile)| Memcached 1.6.31 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[1.6.31-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/memcached/1.6.31/22.03-lts-sp3/Dockerfile)| Memcached 1.6.31 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[1.6.31-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/memcached/1.6.31/22.03-lts-sp4/Dockerfile)| Memcached 1.6.31 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[1.6.31-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/memcached/1.6.31/24.03-lts/Dockerfile)| Memcached 1.6.31 on openEuler 24.03-LTS | amd64, arm64 |
|[1.6.32-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/memcached/1.6.32/22.03-lts-sp1/Dockerfile)| Memcached 1.6.32 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[1.6.32-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/memcached/1.6.32/22.03-lts-sp3/Dockerfile)| Memcached 1.6.32 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[1.6.32-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/memcached/1.6.32/22.03-lts-sp4/Dockerfile)| Memcached 1.6.32 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[1.6.32-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/memcached/1.6.32/24.03-lts/Dockerfile)| Memcached 1.6.32 on openEuler 24.03-LTS | amd64, arm64 |
  
# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/memcached` image from docker

	```bash
	docker pull openeuler/memcached:{Tag}
	```

- Start a memcached instance

	```bash
	docker run -d --name my-memcached -p 11211:11211 openeuler/memcached:{Tag}
	```
	After the instance `my-memcached` is started, access the Memcached service through `http://localhost:11211`.

- Container startup options

	| Option | Description |
	|--|--|
	| `-p 11211:11211` | Expose Memcached server on `localhost:11211`. |
	| `-e MEMCACHED_CACHE_SIZE=64MB` | Determines the size of the cache. |
    | `-e MEMCACHED_MAX_CONNECTIONS=1024`	| Determines the maximum number of concurrent connections. |
    | `-e MEMCACHED_THREADS=4` | Determines the number of threads to process requests. |
    | `-e MEMCACHED_PASSWORD` | Define the password for the `root` user if another username is provided. By default the authentication is disabled but if this option is passed it becomes enabled. |
    | `-e MEMCACHED_USERNAME` | Define a new user. If this option is passed a password is needed to authenticate the new user. |

- View container running logs

	```bash
	docker logs -f my-memcached
	```

- To get an interactive shell

	```bash
	docker exec -it my-memcached /bin/bash
	```
	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).