# Quick reference

- The official Traefik docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Traefik | openEuler
Current Traefik docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Traefik (pronounced traffic) is a modern HTTP reverse proxy and load balancer that makes deploying microservices easy. Traefik integrates with your existing infrastructure components and configures itself automatically and dynamically. Pointing Traefik at your orchestrator should be the only configuration step you need.

Learn more about Traefik on the [Traefik Website](https://doc.traefik.io/).

# Supported tags and respective Dockerfile links
The tag of each `traefik` docker image is consist of the version of `traefik` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[2.11.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/traefik/2.11.0/22.03-lts-sp3/Dockerfile)| Traefik 2.11.0 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[3.1.4-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/traefik/3.1.4/22.03-lts-sp3/Dockerfile)| Traefik 3.1.4 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[3.1.5-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/traefik/3.1.5/22.03-lts-sp3/Dockerfile)| Traefik 3.1.5 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[3.1.6-oe2003sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/traefik/3.1.6/20.03-lts-sp4/Dockerfile)| Traefik 3.1.6 on openEuler 20.03-LTS-SP4 | amd64, arm64 |
|[3.1.6-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/traefik/3.1.6/22.03-lts-sp1/Dockerfile)| Traefik 3.1.6 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[3.1.6-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/traefik/3.1.6/22.03-lts-sp3/Dockerfile)| Traefik 3.1.6 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[3.1.6-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/traefik/3.1.6/22.03-lts-sp4/Dockerfile)| Traefik 3.1.6 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[3.1.6-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/traefik/3.1.6/24.03-lts/Dockerfile)| Traefik 3.1.6 on openEuler 24.03-LTS | amd64, arm64 |
|[3.2.0-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/traefik/3.2.0/22.03-lts-sp1/Dockerfile)| Traefik 3.2.0 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[3.2.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/traefik/3.2.0/22.03-lts-sp3/Dockerfile)| Traefik 3.2.0 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[3.2.0-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/traefik/3.2.0/22.03-lts-sp4/Dockerfile)| Traefik 3.2.0 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[3.2.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/traefik/3.2.0/24.03-lts/Dockerfile)| Traefik 3.2.0 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/traefik` image from docker

	```bash
	docker pull openeuler/traefik:{Tag}
	```

- Start a traefik instance

	```bash
	docker run -d --name my-traefik -p 80:80 openeuler/traefik:{Tag}
	```
	After the instance `my-traefik` is started, access the Traefik service through `http://localhost:80`.

- Container startup options

	| Option | Description |
	|--|--|
	| `-p 80:80` | Expose Traefik  server on `localhost:80`. |
    | `-v /path/to/traefik.yml:/etc/traefik/traefik.yml` | Local Traefik configuration file. |
    
- View container running logs

	```bash
	docker logs -f my-traefik
	```
	
- To get an interactive shell

	```bash
	docker exec -it my-traefik /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).