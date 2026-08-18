# Quick reference

- The official oneDNN docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).
# oneDNN | openEuler
oneAPI Deep Neural Network Library (oneDNN) is an open-source cross-platform performance library of basic building blocks for deep learning applications.

Learn more about oneDNN on [oneAPI Deep Neural Network Library (oneDNN) Developer Guide and Reference — oneDNN v3.13.0 documentation](https://uxlfoundation.github.io/oneDNN/v3.13).

# Supported tags and respective Dockerfile links
The tag of each oneDNN docker image is consist of the version of oneDNN and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[3.13-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/onednn/3.13/24.03-lts-sp4/Dockerfile) | oneDNN 3.13 on openEuler 24.03-lts-sp4 | amd64, arm64 |

# Usage

- Pull the `openeuler/onednn` image from docker

	```bash
	docker pull openeuler/onednn:{Tag}
	```

- Run the bundled `getting_started` example to verify the library works

	```bash
	docker run --rm openeuler/onednn:{Tag}
	```

- View the logs of a container

	```bash
	docker logs <container-name>
	```

- Enter the container to inspect the installed library

	```bash
	docker run -it --rm openeuler/onednn:{Tag} /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
