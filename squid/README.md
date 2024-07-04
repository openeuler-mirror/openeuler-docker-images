# Quick reference

- The official Squid docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Squid | openEuler
Current Squid docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Squid is a caching proxy for the Web supporting HTTP, HTTPS, FTP, and more. It reduces bandwidth and improves response times by caching and reusing frequently-requested web pages. Squid has extensive access controls and makes a great server accelerator. It runs on most available operating systems, including Windows and is licensed under the GNU GPL.

Learn more on [Squid website](https://www.squid-cache.org/).

# Supported tags and respective Dockerfile links
The tag of each `squid` docker image is consist of the version of `squid` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[6.8-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/squid/6.8/22.03-lts-sp3/Dockerfile)| Squid 6.8 on openEuler 22.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/squid` image from docker
	```bash
	docker pull openeuler/squid:{Tag}
	```
- Start a squid instance

	```bash
	docker run -d --name my-squid -p 3128:3128 openeuler/squid:{Tag}
	```
	After the instance `my-squid` is started, access the Squid service through `http://localhost:3128`.

- Container startup options

	| Option | Description |
	|--|--|
	| `-p 3128:3128` | Expose squid on `localhost:3128`. |
	| `-v /path/to/logs:/var/log/squid`	 | Volume to store squid logs |
	| `-v /path/to/data:/var/spool/squid` | Volume to store the squid cache |
	| `-v /path/to/main/config:/usr/local/squid/etc/squid.conf` | Main squid configuration file |
	| `-v /path/to/config/snippet:/usr/local/squid/etc/conf.d/snippet.conf`	 | Configuration snippets included by squid.conf |

- View container running logs

	```bash
	docker logs -f my-squid
	```

- To get an interactive shell

	```bash
	docker exec -it my-squid /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).