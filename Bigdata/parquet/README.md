# Quick reference

- The official parquet docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# parquet | openEuler
Current parquet docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Parquet is an open source, column-oriented data file format designed for efficient data storage and retrieval. It provides high performance compression and encoding schemes to handle complex data in bulk and is supported in many programming language and analytics tools.

For more information about parquet, please visit [https://parquet.apache.org/](https://parquet.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each parquet docker image is consist of the version of parquet and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[2.11.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/parquet/2.11.0/24.03-lts-sp1/Dockerfile)| Apache Parquet 2.11.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage

Users should start a parquet instance by following command:
```bash
docker run -it --name parquet openeuler/parquet:latest
```
If someone needs to use the complete functions, please visit [http://parquet.apache.org/](http://parquet.apache.org/) for setting up parquet.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).