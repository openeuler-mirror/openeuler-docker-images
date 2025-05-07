# Quick reference

- The official Python docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Python | openEuler
Current Python docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Python is a high-level, general-purpose programming language. Its design philosophy emphasizes code readability with the use of significant indentation.

Python is dynamically type-checked and garbage-collected. It supports multiple programming paradigms, including structured (particularly procedural), object-oriented and functional programming. It is often described as a "batteries included" language due to its comprehensive standard library.

# Supported tags and respective Dockerfile links
The tag of each Python docker image is consist of the version of Python and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[3.9.9-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/Others/python/3.9.9/22.03-lts/Dockerfile)| Python 3.9.9 on openEuler 22.03-LTS | amd64, arm64 |
|[3.10.17-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/Others/python/3.10.17/24.03-lts/Dockerfile)| Python 3.10.17 on openEuler 24.03-LTS | amd64, arm64 |


# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/python` image from docker

	```bash
	docker pull openeuler/python:{Tag}
	```

- Start a Python container from the image

	```bash
	docker run -it --name my-python openeuler/python:{Tag}
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
