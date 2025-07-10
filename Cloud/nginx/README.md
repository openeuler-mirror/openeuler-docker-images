# Quick reference

- The official Nginx docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Nginx | openEuler
Current Nginx docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Nginx (pronounced "engine-x") is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3, and IMAP protocols, as well as a load balancer, HTTP cache, and a web server (origin server). The nginx project started with a strong focus on high concurrency, high performance and low memory usage. It is licensed under the 2-clause BSD-like license and it runs on Linux, BSD variants, Mac OS X, Solaris, AIX, HP-UX, as well as on other *nix flavors. It also has a proof of concept port for Microsoft Windows. Learn more on [https://en.wikipedia.org/wiki/Nginx](https://en.wikipedia.org/wiki/Nginx)⁠.

Features:
- Nginx is easy to configure in order to serve static [web content](https://en.wikipedia.org/wiki/Web_content) or to act as a [proxy server](https://en.wikipedia.org/wiki/Proxy_server).

- Nginx can be deployed to also serve [dynamic content](https://en.wikipedia.org/wiki/Dynamic_web_pagehttps://en.wikipedia.org/wiki/Dynamic_web_page) on the network using [FastCGI](https://en.wikipedia.org/wiki/FastCGI), [SCGI](https://en.wikipedia.org/wiki/Simple_Common_Gateway_Interface) handlers for [scripts](https://en.wikipedia.org/wiki/Scripting_languagehttps://en.wikipedia.org/wiki/Scripting_language), [WSGI](https://en.wikipedia.org/wiki/Web_Server_Gateway_Interface) application servers or [Phusion Passenger](https://en.wikipedia.org/wiki/Phusion_Passenger) modules, and can serve as a software load balancer[load balancer](https://en.wikipedia.org/wiki/Load_balancing_%28computing%29).

- Nginx uses an [asynchronous](https://en.wikipedia.org/wiki/Asynchronous_system) [event-driven](https://en.wikipedia.org/wiki/Event_%28computing%29) approach, rather than threads, to handle requests. Nginx's modular [event-driven architecture](https://en.wikipedia.org/wiki/Event-driven_architecture) can provide predictable performance under high loads.

# Supported tags and respective Dockerfile links
The tag of each `nginx` docker image is consist of the version of `nginx` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.16.1-oe2003sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.16.1/20.03-lts-sp1/Dockerfile)| Nginx 1.16.1 on openEuler 20.03-LTS-SP1 | amd64, arm64 |
|[1.21.5-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.21.5/22.03-lts/Dockerfile)| Nginx 1.21.5 on openEuler 22.03-LTS | amd64, arm64 |
|[1.25.4-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.25.4/22.03-lts-sp3/Dockerfile)| Nginx 1.25.4 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[1.27.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.27.0/22.03-lts-sp3/Dockerfile)| Nginx 1.27.0 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[1.27.1-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.27.1/22.03-lts-sp3/Dockerfile)| Nginx 1.27.1 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[1.27.2-oe2003sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.27.2/20.03-lts-sp4/Dockerfile)| Nginx 1.27.2 on openEuler 20.03-LTS-SP4 | amd64, arm64 |
|[1.27.2-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.27.2/22.03-lts-sp1/Dockerfile)| Nginx 1.27.2 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[1.27.2-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.27.2/22.03-lts-sp3/Dockerfile)| Nginx 1.27.2 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[1.27.2-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.27.2/22.03-lts-sp4/Dockerfile)| Nginx 1.27.2 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[1.27.2-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.27.2/24.03-lts/Dockerfile)| Nginx 1.27.2 on openEuler 24.03-LTS | amd64, arm64 |
|[1.29.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.29.0/24.03-lts/Dockerfile)| Nginx 1.29.0 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/nginx` image from docker

	```bash
	docker pull openeuler/nginx:{Tag}
	```

- Start a nginx instance

	```bash
	docker run -d --name my-nginx -p 8080:80 openeuler/nginx:{Tag}
	```
	After the instance `my-nginx` is started, access the Nginx service through `http://localhost:8080`.

- Container startup options

	| Option | Description |
	|--|--|
	| `-p 8080:80` | Expose nginx on `localhost:8080`. |
	| `-v /local/path/to/website:/var/www/html` | Mount and serve a local website. |
	| `-v /path/to/conf.template:/etc/nginx/templates/conf.template`	| Mount template files inside `/etc/nginx/templates`. They will be processed and the results will be placed at `/etc/nginx/conf.d`. (e.g. `listen ${NGINX_PORT}`; will generate `listen 80`). |
	| `-v /path/to/nginx.conf:/etc/nginx/nginx.conf` | Local [configuration file](https://nginx.org/en/docs/)⁠ `nginx.conf`. |

- View container running logs

	```bash
	docker logs -f my-nginx
	```

- To get an interactive shell

	```bash
	docker exec -it my-nginx /bin/bash
	```
	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
