#redis


# Quick reference

- The official redis docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/redis:$VERSION" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

# How to use this image
## start a redis instance
```shell
docker run --name my-redis -d openeuler/redis:{TAG}
```

## Start with persistent storage
```shell
docker run --name my-redis -d openeuler/redis:{TAG} redis-server --save 60 1 --loglevel warning
```
As shows above, this will save a snapshot of the DB every 60 seconds if at least 1 write operation was performed.

## connect to a redis instance
Connect to a local redis instance using loopback address
```shell
docker run --name my-redis -d -p 6379:6379 openeuler/redis:{TAG}
redis-cli -h 127.0.0.1 -p 6379
```

If you want connect the redis instance using hostip, you should connect to the instance using loopback,
and then configure as belows
```shell
config set protected-mode no
```

# Supported tags and respective Dockerfile links

- 6.2.7-oe2203lts: redis v{TAG}, openEuler 22.03 LTS
- 7.2.4-oe2203sp3: redis v7.2.4, openEuler 22.03 LTS SP3

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.
