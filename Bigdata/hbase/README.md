# Quick reference

- The official hbase docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# hbase | openEuler
Current hbase docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache HBase is an open-source, distributed, versioned, column-oriented store modeled after Google' Bigtable.

Learn more on [hbase website](https://hbase.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each hbase docker image is consist of the version of hbase and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[2.6.2-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/hbase/2.6.2/24.03-lts-sp1/Dockerfile)| Apache HBase 2.6.2 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
Start a hbase instance by following command:
```bash
docker run -it \
    --name hbase \
    openeuler/hbase:latest
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).