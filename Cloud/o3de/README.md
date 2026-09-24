# Quick reference

- The official O3DE docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# O3DE | openEuler
Current O3DE docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Open 3D Engine (O3DE) is an open-source, modular 3D engine for developing AAA games and high-fidelity simulations. Read more on the [official documentation](https://o3de.org/docs/).

# Supported tags and respective Dockerfile links
The tag of each `o3de` docker image is consist of the version of `o3de` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[2605.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Cloud/o3de/2605.0/24.03-lts-sp4/Dockerfile) | o3de 2605.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[2409.2-oe2403sp1](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Cloud/o3de/2409.2/24.03-lts-sp1/Dockerfile) | O3DE 2409.2 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/o3de` image from docker

	```bash
	docker pull openeuler/o3de:{Tag}
	```

- Run an interactive shell

	```bash
	docker run -it --rm openeuler/o3de:{Tag} bash
	```

	The engine source tree and build configuration are located under `/o3de`.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).