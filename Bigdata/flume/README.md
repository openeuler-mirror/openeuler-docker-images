# Quick reference

- The official flume docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# flume | openEuler
Current flume docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Flume is a distributed, reliable, and available service for efficiently collecting, aggregating, and moving large amounts of log-like data.

Learn more on [flume website](https://flume.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each flume docker image is consist of the version of flume and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.11.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/flume/1.11.0/24.03-lts-sp1/Dockerfile)| flume 1.11.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
Start a flume instance by following command:
```bash
docker run -it \
    --name flume \
    openeuler/flume:latest
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).