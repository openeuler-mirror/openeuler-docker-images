# openEuler Basic Container Images

# Quick reference

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Download all images:

```shell
download.sh
```

2. Build images and push:
```shell
docker buildx build -t "openeuler/openeuler:$VERSION" --platform linux/amd64,linux/arm64,linux/loong64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)


# Supported tags and respective Dockerfile links

- 23.09
- 23.03
- 22.09
- 22.03-lts-sp2
- 22.03-lts-sp1
- 22.03-lts
- 21.03
- 20.09
- 20.03-lts-sp2
- 20.03-lts-sp1, 20.03, latest
- 20.03-lts


## Operating System
Linux/Unix, ARM64 or x86-64 architecture.

