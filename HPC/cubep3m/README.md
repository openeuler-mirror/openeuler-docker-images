# Quick reference

- The official CubeP3M docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# CubeP3M | openEuler
Current CubeP3M docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

CubeP3M is a high performance cosmological N-body code which has many utilities and extensions, including a runtime halo finder, a non-Gaussian initial conditions generator, a tuneable accuracy, and a system of unique particle identification. 

Learn more on [CubeP3M website](https://github.com/jharno/cubep3m).


# Supported tags and respective Dockerfile links
The tag of each cubep3m docker image is consist of the version of CubeP3M and the version of basic image. The details are as follows

| Tags | Currently |  Architectures|
|------|-----------|---------------|
|[1.0.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/cubep3m/1.0.0/24.03-lts/Dockerfile)| CubeP3M 1.0.0 on openEuler 24.03-LTS | amd64, arm64 |


# Usage
- Pull the `openeuler/cubep3m` image from `hub.docker.com`
	```
	docker pull openeuler/cubep3m:{Tag}
	```
- Start a `cubep3m` instance
	```
	docker run -it --name my-cubep3m openeuler/cubep3m:{Tag}
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).