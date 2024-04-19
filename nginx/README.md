# Nginx

# Quick reference

- The official Nginx docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/nginx:$VERSION" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

2. Run:
```shell
docker run -d openeuler/nginx:$VERSION
```

# Supported tags and respective Dockerfile links

- 1.16.1-20.03-lts-sp1: nginx v1.16.1, openEuler 20.03 LTS SP1
- 1.21.5-22.03-lts: nginx v1.21.5, openEuler 22.03 LTS
- 1.25.4-22.03-lts-sp3: nginx v1.25.4, openEuler 22.03 LTS SP3

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.
