# memcached

# Quick reference

- The official memcached docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/memcached:$VERSION" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

# How to use this image
```shell
docker run --name my_memcached -d -p 11211:11211 openeuler/memcached:$VERSION
```

# Supported tags and respective Dockerfile links

- 1.6.12-oe2203lts: memcached v1.6.12, openEuler 22.03 LTS
- 1.6.24-oe2203sp3: memcached v1.6.24, openEuler 22.03 LTS SP3

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.
