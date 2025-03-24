# Python

# Quick reference

- The official Python docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/python:$VERSION" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

2. Run:
```shell
docker run -d openeuler/python:3.9.9-22.03-lts
```

# Supported tags and respective Dockerfile links

- 3.9.9-22.03-lts: python v3.9.9, openEuler 22.03 LTS

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.
