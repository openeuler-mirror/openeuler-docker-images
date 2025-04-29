# Quick reference

- The official guacd docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Guacd | openEuler
Current guacd docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Guacd is the native server-side proxy used by the Apache Guacamole web application. If you wish to deploy Guacamole, or an application using the Guacamole core APIs, you will need a copy of guacamole-server running.

Learn more on [Apache Guacamole-server Website](https://guacamole.apache.org/doc/gug/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `guacd` docker image is consist of the version of `guacd` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.5.5-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/guacd/1.5.5/24.03-lts/Dockerfile)| Apache guacamole-server 1.5.5 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/guacd` image from docker

	```bash
	docker pull openeuler/guacd:{Tag}
	```

- Start a guacd instance

	```bash
	docker run -d --name my-guacd openeuler/guacd:{Tag}
	```
	After the instance `my-guacd` is started, guacd will be listening on port 4822, but this port will only be available to Docker containers that have been explicitly linked to my-guacd.

- View container running logs

	```bash
	docker logs -f my-guacd
	```

- To get an interactive shell

	```bash
	docker exec -it my-guacd /bin/bash
	```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).