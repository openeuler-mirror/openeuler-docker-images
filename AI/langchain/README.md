# Quick reference

- The official LangChain(Deep Learning Recommendation Model) docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Dotnet-aspnet（ASP.NET Core） | openEuler
Current LangChain(Deep Learning Recommendation Model) docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

# Supported tags and respective Dockerfile links
- langchain 1.0 on openEuler 22.03-LTS-SP4 | amd64, arm64 |

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/langchain:$TAG" --platform linux/amd64,linux/arm64 . --push
```

2. Run:
```shell
docker run -itd --name langchain openeuler/langchain:$TAG
docker exec -it langchain /bin/bash
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
