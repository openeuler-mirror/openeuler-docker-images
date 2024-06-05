# Spark

# Quick reference

- The Apache Spark docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/spark:$VERSION" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

2. Run:
```shell
docker run -d openeuler/spark:$VERSION
```

# Supported tags and respective Dockerfile links

- 3.3.1-oe2203lts: spark 3.3.1, openEuler 22.03 LTS
- 3.3.2-oe2203lts: spark 3.3.2, openEuler 22.03 LTS
- 3.4.0-oe2203lts: spark 3.4.0, openEuler 22.03 LTS

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.
