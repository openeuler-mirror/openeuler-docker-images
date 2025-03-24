# rabbitmq

# Quick reference

- The official prometheus docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/rabbitmq:$VERSION" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

# How to use this image
```shell
docker run --name my_rabbitmq -d -p 5672:5672 -p 15672:15672 openeuler/rabbitmq:$VERSION
```

# Supported tags and respective Dockerfile links

- 3.9.10-22.03-lts: rabbitmq v3.9.10, openEuler 22.03 LTS

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.
