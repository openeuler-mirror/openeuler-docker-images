# openssh-server

# Quick reference

- The official openssh-server docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/openssh-server:$VERSION" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

2. Run:
## Key Generation
```shell
docker run --rm -it --entrypoint /keygen.sh openeuler/openssh-server:$VERSION
```
## Run as daemon
```shell
docker run -d openeuler/openssh-server:$VERSION
```

# Supported tags and respective Dockerfile links

- 8.8_p1-22.03-lts: python v8.8_p1, openEuler 22.03 LTS

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.
