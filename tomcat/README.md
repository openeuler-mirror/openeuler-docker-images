# Tomcat

# Quick reference

- The official Tomcat docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

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

# Supported tags and respective Dockerfile links

- 9.0.10-20.03-lts-sp1: tomcat v9.0.10, openEuler 20.03 LTS SP1

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.
