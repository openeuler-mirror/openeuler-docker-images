# Quick reference

- The official PyPI docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# PyPI | openEuler
Current PyPI docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

pip is the package installer for Python. You can use pip to install packages from the Python Package Index and other indexes.

Learn more on [pip documentation](https://pip.pypa.io/).

# Supported tags and respective Dockerfile links
The tag of each `pypi` docker image is consist of the version of `pypi` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
| [23.3.1-oe2403sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/pypi/23.3.1/24.03-lts-sp4/Dockerfile) | PyPI 23.3.1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/pypi` image from docker

	```bash
	docker pull openeuler/pypi:{Tag}
	```

- Start a pypi instance to install packages

	```bash
	docker run -it openeuler/pypi:{Tag} pip install <package-name>
	```
