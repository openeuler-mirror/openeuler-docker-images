# Quick reference

- The official avro docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# avro | openEuler
Current avro docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Avro is the leading serialization format for record data, and first choice for streaming data pipelines.

Learn more on [avro website](https://avro.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each avro docker image is consist of the version of avro and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.12.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/avro/1.12.0/24.03-lts-sp1/Dockerfile)| Apache Avro 1.12.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
Avro containers should be used as a devel environment, start a avro instance by following command:
```bash
docker run -it \
    --name avro \
    openeuler/avro:latest
```

Users can develope their projects based on avro.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).