# Quick reference

- The official Dlrm(Deep Learning Recommendation Model) docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Dotnet-aspnet（ASP.NET Core） | openEuler
Current Dlrm(Deep Learning Recommendation Model) docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Deep Learning Recommendation Model for Personalization and Recommendation Systems,Copyright (c) Facebook, Inc. and its affiliates。

# Supported tags and respective Dockerfile links
The tag of each dlrm docker image is consist of the version of dlrm and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/dlrm/1.0/22.03-lts-SP3/Dockerfile)| Dlrm 1.0 on openEuler 22.03-LTS-SP3 | amd64, arm64 |

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/dlrm:$TAG" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

2. Run:
```shell
docker run -itd --name dlrm openeuler/dlrm:$TAG
docker exec -it dlrm /bin/bash
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).