# Quick reference

- The official Triton docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# Triton | openEuler
Current triton docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Triton is a language and compiler for writing highly efficient custom Deep-Learning primitives.

Learn more on [Welcome to Triton's documentation! — Triton documentation](https://triton-lang.org)⁠.

# Supported tags and respective Dockerfile links
The tag of each `triton` docker image is consist of the version of `triton` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[3.7.1-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/triton/3.7.1/24.03-lts-sp4/Dockerfile) | triton 3.7.1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/triton` image from docker

	```bash
	docker pull openeuler/triton:{Tag}
	```

- Start a triton container instance

	```bash
	docker run --rm openeuler/triton:{Tag}
	```
	After the triton container starts, it will display the installed version of triton.

- Start an interactive Python shell to use the triton library

	```bash
	docker run -it --rm openeuler/triton:{Tag} python3
	```

- View container running logs

	```bash
	docker logs -f my-triton
	```

- To get an interactive shell

	```bash
	docker exec -it my-triton /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
