# Quick reference

- The official git docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# git | openEuler
Current git docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Learn more on [git website](https://git.org/).

# Supported tags and respective Dockerfile links
The tag of each `git` docker image is consist of the version of `git` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[2.47.2-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/git/2.47.2/24.03-lts/Dockerfile) | git 2.47.2 on openEuler 24.03-lts | amd64, arm64 |

# Usage
```
docker run -d --name my-git -p 80:80 openeuler/git:{{Tag}}
```
To stop and remove the container, use these commands.
```
docker stop my-git
docker rm my-git
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
