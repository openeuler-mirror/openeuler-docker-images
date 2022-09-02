# PostgreSQL

# Quick reference

- The official openGauss-lite docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/postgres:$VERSION" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

# How to use this image
## start a openGauss instance
```shell
docker run --name my_postgresql -d -e POSTGRES_PASSWORD=PostgreSQL@123 openeuler/postgres:13.3
```
The default postgres user and database are created in the entrypoint with initdb.

## connect database using gsql from os
```shell
docker run --name my_postgresql -d -e POSTGRES_PASSWORD=PostgreSQL@123 -p5433:5432 openeuler/postgres:13.3
psql -d postgres -U postgres -W 'PostgreSQL@123' -h host_ip -p 5433
```

## persist data to local storage
```shell
docker run --name my_postgresql -d -e POSTGRES_PASSWORD=PostgreSQL@123 -v /postgresql:/var/lib/pgsql/data openeuler/postgres:13.3
```

# Supported tags and respective Dockerfile links

- 13.3-22.03-lts: postgres v13.3, openEuler 22.03 LTS

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.
