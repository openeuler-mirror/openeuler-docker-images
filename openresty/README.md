# Quick reference

- The official OpenResty docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# OpenResty | openEuler
Current OpenResty docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

OpenResty is a full-fledged web platform that integrates our enhanced version of the Nginx core, our enhanced version of LuaJIT, many carefully written Lua libraries, lots of high quality 3rd-party Nginx modules, and most of their external dependencies. It is designed to help developers easily build scalable web applications, web services, and dynamic web gateways. Learn more on [https://openresty.org/en/](https://openresty.org/en/)⁠.

Features:
- OpenResty® is a full-fledged web platform that integrates our enhanced version of the Nginx core, our enhanced version of LuaJIT, many carefully written Lua libraries, lots of high quality 3rd-party Nginx modules, and most of their external dependencies. It is designed to help developers easily build scalable web applications, web services, and dynamic web gateways.

- By taking advantage of various well-designed Nginx modules (most of which are developed by the OpenResty team themselves), OpenResty® effectively turns the nginx server into a powerful web app server, in which the web developers can use the Lua programming language to script various existing nginx C modules and Lua modules and construct extremely high-performance web applications that are capable to handle 10K ~ 1000K+ connections in a single box.

- OpenResty® aims to run your server-side web app completely in the Nginx server, leveraging Nginx's event model to do non-blocking I/O not only with the HTTP clients, but also with remote backends like MySQL, PostgreSQL, Memcached, and Redis.

# Supported tags and respective Dockerfile links
The tag of each `openresty` docker image is consist of the version of `openresty` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.21.4.1-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/openresty/1.21.4.1/22.03-lts-sp3/Dockerfile)| openresty 1.21.4.1 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[1.25.3.1-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/openresty/1.25.3.1/22.03-lts-sp3/Dockerfile)| openresty 1.25.3.1 on openEuler 22.03-LTS-SP3 | amd64, arm64 |



# Dependent version

| Tag                                                          | OpenResty | Nginx-core | LuaJit       |
| ------------------------------------------------------------ | --------- | ---------- | ------------ |
| [1.21.4.1-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/openresty/1.21.4.1/22.03-lts-sp3/Dockerfile) | 1.21.4.1  | 1.21.4     | 2.1-20220411 |
| [1.25.3.1-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/openresty/1.25.3.1/22.03-lts-sp3/Dockerfile) | 1.25.3.1  | 1.25.3     | 2.1-20231117 |



# Usage

In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/openresty` image from docker

	```bash
	docker pull openeuler/openresty:{Tag}
	```

- Start a openresty instance

	```bash
	docker run -d --name my-openresty -p 8080:80 openeuler/openresty:{Tag}
	```
	After the instance `my-openresty` is started, access the openresty service through `http://localhost:8080`.

- Container startup options

	| Option | Description |
	|--|--|
	| `-p 8080:80` | Expose nginx on `localhost:8080`. |
	| `-v /local/path/to/website:/usr/local/nginx/html` | Mount and serve a local website. |
	| `-v /path/to/nginx.conf:/usr/local/openresty/nginx/conf/nginx.conf` | Local [configuration file](https://nginx.org/en/docs/)⁠ `nginx.conf`. |

- View container running logs

	```bash
	docker logs -f my-openresty
	```

- To get an interactive shell

	```bash
	docker exec -it my-openresty /bin/bash
	```
	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).