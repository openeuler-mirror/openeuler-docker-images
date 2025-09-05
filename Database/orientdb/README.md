# Quick reference

- The official orientdb docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# orientdb | openEuler
Current orientdb docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

OrientDB is the most versatile DBMS supporting Graph, Document, Reactive, Full-Text and Geospatial models in one Multi-Model product. OrientDB can run distributed (Multi-Master), supports SQL, ACID Transactions, Full-Text indexing and Reactive Queries.

For more information about orientdb, please visit [https://orientdb.dev/](https://orientdb.dev/).

# Supported tags and respective Dockerfile links
The tag of each orientdb docker image is consist of the version of orientdb and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[3.2.44-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/orientdb/3.2.44/24.03-lts-sp1/Dockerfile) | orientdb 3.2.44 on openEuler 24.03-LTS-SP1 | amd64, arm64 |
|[3.2.38-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/orientdb/3.2.38/24.03-lts-sp1/Dockerfile)| OrientDB 3.2.38 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage

This image is used to verify if the upstream orientdb version can be integrated with openEuler, users should sutup orientdb by themselves.

Start a orientdb instance by following command:
```bash
docker run -it --name orientdb openeuler/orientdb:latest
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).