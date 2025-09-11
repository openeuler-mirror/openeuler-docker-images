# Node.js 

# Quick reference

- The official Node.js docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/node:$VERSION" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

2. Run:
```shell
docker run -ti openeuler/node:10.21.0-20.03-lts-sp1
```

# Supported tags and respective Dockerfile links

- 10.21.0-20.03-lts-sp1: node v10.21.0, openEuler 20.03 LTS SP1

# Supported tags and respective Dockerfile links
The tag of each `next` docker image is consist of the version of `next` and the version of basic image. The details are as follows

| Tag                                                                                                                                   | Currently                                 | Architectures |
|---------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|---------------|
|[24.8.0-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/node/24.8.0/24.03-lts-sp2/Dockerfile) | node 24.8.0 on openEuler 24.03-LTS-SP2 | amd64, arm64 |
| [10.21.0-20.03-lts-sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/node/10.21.0/20.03-lts-sp1/Dockerfile) | Nodejs 10.21.0 on openEuler 20.03-LTS-SP1 | amd64, arm64  |
| [20.11.1-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/node/20.11.1/24.03-lts/Dockerfile)         | Nodejs 20.11.1 on openEuler 24.03-LTS     | amd64, arm64  |
| [20.18.2-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/node/20.18.2/24.03-lts-sp1/Dockerfile)     | Nodejs 20.18.2 on openEuler 24.03-LTS-SP1 | amd64, arm64  |
| [24.4.0-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/node/24.4.0/24.03-lts-sp2/Dockerfile)       | Nodejs 24.4.0 on openEuler 24.03-LTS-SP2  | amd64, arm64  |


## Operating System
Linux/Unix, ARM64 or x86-64 architecture.