# Quick reference

- The official Conda docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Conda | openEuler
Current Conda docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Conda is an open-source package management system and environment management system that runs on Windows, macOS, and Linux. Conda quickly installs, runs, and updates packages and their dependencies. Conda easily creates, saves, loads, and switches between environments on your local computer.

Learn more on [Conda documentation](https://docs.conda.io/).

# Supported tags and respective Dockerfile links
The tag of each `conda` docker image is consist of the version of `conda` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
| [25.1.1-oe2403sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/conda/25.1.1/24.03-lts-sp4/Dockerfile) | Conda 25.1.1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/conda` image from docker

	```bash
	docker pull openeuler/conda:{Tag}
	```

- Start a conda instance

	```bash
	docker run -it openeuler/conda:{Tag} bash
	```

- Create a conda environment

	```bash
	conda create -n myenv python=3.10
	conda activate myenv
	```
