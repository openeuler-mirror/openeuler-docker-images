# Quick reference

- The official lucene docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# lucene | openEuler
Current lucene docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Lucene is a high-performance, full-featured text search engine library written in Java.

# Supported tags and respective Dockerfile links
The tag of each lucene docker image is consist of the version of lucene and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[10.2.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/lucene/10.2.1/24.03-lts-sp1/Dockerfile)| Apache Lucene 10.2.1 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
Start a lucene instance by following command:
```bash
docker run -it --name lucene openeuler/lucene:latest
```

When the container is ready, you will see the following scripts in `WORKDIR`
```
[root@1c6b6f671ed5 bin]# ls
luke.cmd  luke.sh

```
For more information about lucene, please visit [https://lucene.apache.org/](https://lucene.apache.org/).

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).