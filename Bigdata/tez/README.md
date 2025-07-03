# Quick reference

- The official tez docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# tez | openEuler
Current tez docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Tez is a generic data-processing pipeline engine envisioned as a low-level engine for higher abstractions such as Apache Hadoop Map-Reduce, Apache Pig, Apache Hive etc.

For more information about tez, please visit [https://tez.apache.org/](https://tez.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each tez docker image is consist of the version of tez and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[0.10.5-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/tez/0.10.5/24.03-lts-sp1/Dockerfile)| Apache Tez 0.10.5 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage

This image is used to verify if the upstream tez version can be integrated with openEuler, please setup tez first while use it.

Start a tez instance by following command:
```bash
docker run -it --name tez openeuler/tez:latest
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).