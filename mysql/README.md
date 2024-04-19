# MySQL

# Quick reference

- The official mysql docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/mysql:$TAG" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

2. Run:
```shell
docker run -d --name my-mysql -p 30306:3306 -e MYSQL_ROOT_PASSWORD=openEuler:S3cr3t/ openeuler/mysql:{Tag}
```
where `mysql` is the name you want to assign to your container, `openEuler:S3cr3t/` is the password to be set for the MySQL root user.

# Supported tags and respective Dockerfile links

- 8.3.0-oe2203sp3: mysql v8.3.0, openEuler 22.03 LTS SP3

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.
