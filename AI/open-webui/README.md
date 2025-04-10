# open-webui

# Quick reference

- The official dlrm docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/open-webui:$TAG" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

2. Run:
```shell
docker run -itd --name openwebui openeuler/open-webui:$TAG
docker exec -it openwebui /bin/bash
```

# Supported tags and respective Dockerfile links

- 1.0-oe2203sp4: open-webui v1.0, openEuler 22.03 LTS SP4

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.
