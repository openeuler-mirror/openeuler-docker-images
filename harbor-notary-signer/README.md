# Harbor Notary Signer

## Quick reference

- The official Harbor Notary Signer docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

## Build reference

- Build images and push

```shell
docker buildx build -t "openeuler/harbor-notary-signer:$VERSION" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

- Run

```shell
docker run -d openeuler/harbor-notary-signer:$VERSION
```

## Supported tags and respective Dockerfile links

- 2.4.1-22.09: harbor-notary-signer v2.4.1, openEuler 22.09

## Operating System

Linux/Unix, ARM64 or x86-64 architecture.
