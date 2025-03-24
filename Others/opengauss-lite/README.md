# openGauss-lite

# Quick reference

- The official openGauss-lite docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/opengauss-lite:$VERSION" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

# How to use this image
## start a openGauss instance
```shell
docker run --name opengauss --privileged=true -d -e GS_PASSWORD=openGauss@123 openeuler/opengauss-lite:2.1.0
```

## connect database using gsql from os
```shell
docker run --name opengauss --privileged=true -d -e GS_PASSWORD=openGauss@123 -p5433:5432 openeuler/opengauss-lite:2.1.0
gsql -d postgres -U gaussdb -W 'openGauss@123' -h host_ip -p 5433
```

## persist data to local storage
```shell
docker run --name opengauss --privileged=true -d -e GS_PASSWORD=openGauss@123 -v /opengauss:/var/lib/opengauss/data openeuler/opengauss-lite:2.1.0
```

# Supported tags and respective Dockerfile links

- 2.1.0-22.03-lts: openGauss-lite v2.1.0, openEuler 22.03 LTS

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.
