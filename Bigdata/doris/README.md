# Quick reference

- The official doris docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# doris | openEuler
Current doris docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Doris is an easy-to-use, high-performance and real-time analytical database based on MPP architecture, known for its extreme speed and ease of use. It only requires a sub-second response time to return query results under massive data and can support not only high-concurrency point query scenarios but also high-throughput complex analysis scenarios.

Learn more on [doris website](https://doris.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each doris docker image is consist of the version of doris and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[2.1.9-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/doris/2.1.9/24.03-lts-sp1/Dockerfile)| doris 2.1.9 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
Start a doris instance by following command:
```bash
docker run -it openeuler/doris:latest
```
Please use doris according to [Doris Doc](https://doris.apache.org/).

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).