# prometheus

# Quick reference

- The official prometheus docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/prometheus:$VERSION" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

# How to use this image
```shell
docker run --name my_prometheus -d -p 9090:9090 openeuler/prometheus:$VERSION
```

# Supported tags and respective Dockerfile links

- 2.20.0-oe2203lts: prometheus v2.20.0, openEuler 22.03 LTS
- 2.50.1-oe2203sp3: prometheus v2.50.1, openEuler 22.03 LTS SP3

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.
