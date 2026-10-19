# Quick reference

- The official OpenViking docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).
# OpenViking | openEuler
Current OpenViking docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

OpenViking is a self-evolving context database for AI agents. It unifies agent memory, knowledge RAG and skills behind one server, and ships a web console (OpenViking Studio) plus a gateway and CLI.

Learn more about OpenViking on [OpenViking](https://openviking.ai).

# Supported tags and respective Dockerfile links
The tag of each `openviking` docker image is consist of the version of `openviking` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[0.5.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/AI/openviking/0.5.0/24.03-lts-sp4/Dockerfile) | openviking 0.5.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/openviking` image from docker

	```bash
	docker pull openeuler/openviking:{Tag}
	```

- Initialize the configuration (writes `~/.openviking/ov.conf`)

	```bash
	docker run -it --rm -v ~/.openviking:/root/.openviking openeuler/openviking:{Tag} openviking-server init
	```

- Start the OpenViking server

	```bash
	docker run -itd --name my-openviking -p 1933:1933 -v ~/.openviking:/root/.openviking openeuler/openviking:{Tag}
	```

	The server listens on port `1933`, and the bundled OpenViking Studio console is served from the same port.

- Use the OpenViking CLI

	```bash
	docker exec -it my-openviking ov --help
	```

- View container logs

	```bash
	docker logs -f my-openviking
	```

- Open an interactive shell

	```bash
	docker exec -it my-openviking /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
