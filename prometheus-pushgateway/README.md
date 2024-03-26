# Prometheus-pushgateway

# Quick reference

- The official prometheus-pushgateway docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/prometheus-pushgateway:$TAG" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

2. Run:
```shell
docker run -d -p 9091:9091 openeuler/prometheus-pushgateway:$TAG
```

# Supported tags and respective Dockerfile links

- 1.7.0-oe2203sp3: prometheus-pushgateway v1.7.0, openEuler 22.03-LTS-SP3

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.
