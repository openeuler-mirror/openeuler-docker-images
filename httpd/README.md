# Quick reference

- The official Httpd docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Httpd | openEuler
Current Httpd docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

The Apache HTTP Server, colloquially called Apache, is a Web server application notable for playing a key role in the initial growth of the World Wide Web. Originally based on the NCSA HTTPd server, development of Apache began in early 1995 after work on the NCSA code stalled. Apache quickly overtook NCSA HTTPd as the dominant HTTP server, and has remained the most popular HTTP server in use since April 1996.

Learn more on [Httpd Website](https://httpd.apache.org/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `httpd` docker image is consist of the version of `httpd` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[2.4.51-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/httpd/2.4.51/22.03-lts/Dockerfile)| Apache HTTP Server 2.4.51 on openEuler 22.03-LTS | amd64, arm64 |
|[2.4.58-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/httpd/2.4.58/22.03-lts-sp3/Dockerfile)| Apache HTTP Server 2.4.58 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[2.4.62-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/httpd/2.4.62/22.03-lts-sp1/Dockerfile)| Apache HTTP Server 2.4.62 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[2.4.62-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/httpd/2.4.62/22.03-lts-sp3/Dockerfile)| Apache HTTP Server 2.4.62 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[2.4.62-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/httpd/2.4.62/22.03-lts-sp4/Dockerfile)| Apache HTTP Server 2.4.62 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[2.4.62-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/httpd/2.4.62/24.03-lts/Dockerfile)| Apache HTTP Server 2.4.62 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/httpd` image from docker

	```bash
	docker pull openeuler/httpd:{Tag}
	```

- Start a httpd instance

	```bash
	docker run -d --name my-httpd -p 80:80 openeuler/httpd:{Tag}
	```
	After the instance `my-httpd` is started, access the httpd service through `http://localhost:80`.

- Container startup options

	| Option | Description |
	|--|--|
	| `-p 80:80` | Expose httpd on `localhost:8080`. |
	| `-v /local/path/to/website:/var/www/html` | 	Mount the local website path `/var/www/html`. |
	| `-v /path/to/httpd.conf:/usr/local/apache2/conf/httpd.conf` | Local configuration file `httpd.conf`. |

- View container running logs

	```bash
	docker logs -f my-httpd
	```

- To get an interactive shell

	```bash
	docker exec -it my-httpd /bin/bash
	```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).