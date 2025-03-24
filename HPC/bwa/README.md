# BWA

# Quick reference

- The official BWA docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/bwa:$VERSION" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

2. Run:
```shell
docker run -ti openeuler/bwa:$VERSION
```

# Supported tags and respective Dockerfile links

- 0.7.18-oe2203sp3: bwa v0.7.18, openEuler 22.03-lts-sp3

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.

