# ZooKeeper

# Quick reference

- The official ZooKeeper docker image.

- Maintained by: [openEuler BigData SIG](https://gitee.com/openeuler/bigdata)

- Where to get help: [openEuler BigData SIG](https://gitee.com/openeuler/bigdata), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/zookeeper:$VERSION" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

# How to use this image

```shell
docker run --name zookeeper --restart always -p 2181:2181 -d openeuler/zookeeper:{TAG}
```

# Supported tags and respective Dockerfile links

- 3.8.3-oe2203sp3: zookeeper v3.8.3, openEuler 22.03-LTS-SP3

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.