# Tomcat

# Quick reference

- The official Tomcat docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Supported tags and respective Dockerfile links
The tag of each `tomcat` docker image is consist of the version of `tomcat` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[11.0.10-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/tomcat/11.0.10/24.03-lts-sp1/Dockerfile) | tomcat 11.0.10 on openEuler 24.03-LTS-SP1 | amd64, arm64 |
|[9.0.10-oe2003sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/tomcat/9.0.10/20.03-lts-sp1/Dockerfile)| Tomcat 9.0.10 on openEuler 20.03-LTS-SP1 | amd64, arm64 |
|[11.0.7-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/tomcat/11.0.7/24.03-lts-sp1/Dockerfile)| Tomcat 11.0.7 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/tomcat:$VERSION" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

2. Run:
```shell
docker run -d openeuler/tomcat:9.0.10-20.03-lts-sp1
```

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.