# Dotnet-runtime

# Quick reference

- The official dotnet-runtime docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/dotnet-runtime:$TAG" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

2. Run:
```shell
docker run -it --rm -name dotnet-runtime openeuler/dotnet-runtime:$TAG
```

# Supported tags and respective Dockerfile links

- 8.0.3-oe2203sp3: dotnet-runtime v8.0.3, openEuler 22.03 LTS SP3

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.
