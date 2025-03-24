# Quick reference

- The official Yambo docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Yambo | openEuler
Current Yambo docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

YAMBO is an open-source code released within the GPL licence implementing first-principles methods based on Green’s function theory to describe excited-state properties of realistic materials.These methods include the GW approximation, the Bethe-Salpeter equation (BSE), electron-phonon interaction and non-equilibrium Green’s function theory (NEGF).

Learn more on [Yambo](https://www.yambo-code.eu/).

# Supported tags and respective Dockerfile links
The tag of each `Yambo` docker image is consist of the version of `Yambo` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[5.3.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Yambo/5.3.0/24.03-lts/Dockerfile)| Yambo 5.3.0 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
Here, users can select the corresponding `{Tag}` by their requirements.

- Pull the `openeuler/yambo` image from docker

	```
	docker pull openeuler/yambo:{Tag}
	```

- Run and test `yambo` container

	```
	docker run -it --rm openeuler/yambo:{Tag}
	```
	From here, users can test yambo as follows
	```
	./bin/yambo --version
	``` 
	The result will looks like:
	```
	This is yambo - Serial+HDF5_IO - Ver. 5.3.0 Revision 23900 Hash e51825f30d
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).