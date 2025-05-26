# Quick reference

- The official open-webui docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# open-webui | openEuler
Current open-webui docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

# Supported tags and respective Dockerfile links
The tag of each `open-webui` docker image is consist of the complete software stack version. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[0.1.108-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/open-webui/0.1.108/22.03-lts-sp4/Dockerfile)| open-webui 0.1.108 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[0.1.108-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/open-webui/0.1.108/24.03-lts-sp1/Dockerfile)| open-webui 0.1.108 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/open-webui` image from docker

	```bash
	docker pull openeuler/open-webui:{Tag}
	```

- Start a open-webui instance

	```bash
	docker run \
        --name my-open-webui \
        -p 8080:8080 \
        -itd openeuler/open-webui:{Tag}
	```

- Container startup options

	| Option | Description |
	|--|--|
    | `--name my-open-webui` | Names the container `my-open-webui`. |
    | `-p 8080:8080` | Mapping port 8080 of host machine to port 8080 of docker container,8080 is the web service port of open-webui. |
    | `-itd` | Starts the container in interactive mode. |
    | `openeuler/open-webui:{Tag}` | Specifies the Docker image to run, replace `{Tag}` with the specific version or tag of the `openeuler/open-webui` image you want to use. |

- View container running logs

	```bash
	docker logs -f my-open-webui
	```

- To get an interactive shell

	```bash
	docker exec -it my-open-webui /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
