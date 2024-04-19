# Telegraf

# Quick reference

- The official telegraf docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/telegraf:$VERSION" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

2. Run:

```shell
docker run --name telegraf -d -v /your-path/telegraf.conf:/etc/telegraf/telegraf.conf openeuler/telegraf:{TAG}
```

# Supported tags and respective Dockerfile links

- 1.29.5-oe2203sp3: telegraf v1.29.5, openEuler 22.03 LTS SP3

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.
