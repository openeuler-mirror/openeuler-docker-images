# cassandra

# Quick reference

- The official cassandra docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/CloudNative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/CloudNative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/cassandra:$VERSION" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

# How to use this image

```shell
docker run --name cassandra openeuler/cassandra:{TAG}
```

# Supported tags and respective Dockerfile links

- 4.1.4-oe2203sp3: cassandra v4.1.4, openEuler 22.03-LTS-SP3

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.