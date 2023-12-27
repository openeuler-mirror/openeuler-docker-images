#httpd


# Quick reference

- The official redis docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

Build images and push:
```shell
docker buildx build -t "openeuler/httpd:httpd2.4.51-oe2203lts" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

# How to use this image
## start a httpd instance
```shell
docker run --name my-httpd -d -p 80:80 openeuler/httpd:httpd2.4.51-oe2203lts
```

# Supported tags and respective Dockerfile links

- httpd2.4.51-oe2203lts: httpd v2.4.51, openEuler 22.03 LTS

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.
