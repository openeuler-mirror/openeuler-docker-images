# grafana

# Quick reference

- The official grafana docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/grafana:$VERSION" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

# How to use this image
```shell
docker run --name my_grafana -d -p 3000:3000 openeuler/grafana:$VERSION
```

# Supported tags and respective Dockerfile links

- 7.5.11-22.03-lts: grafana v7.5.11, openEuler 22.03 LTS

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.
