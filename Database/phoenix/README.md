# Quick reference

- The official phoenix docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# phoenix | openEuler
Current phoenix docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Phoenix is a SQL skin over HBase delivered as a client-embedded JDBC driver targeting low latency queries over HBase data. 

For more information about phoenix, please visit [https://phoenix.apache.org/](https://phoenix.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each phoenix docker image is consist of the version of phoenix and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[5.2.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/phoenix/5.2.1/24.03-lts-sp1/Dockerfile)| phoenix 5.2.1 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage

This image is used to verify if the upstream phoenix version can be integrated with openEuler, users should sutup phoenix by themselves.

Users should start a phoenix instance by following command:
```bash
docker run -it --name phoenix openeuler/phoenix:latest
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).