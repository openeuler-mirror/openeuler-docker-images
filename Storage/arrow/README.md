# Quick reference

- The official arrow docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# arrow(arrow Storage Stack) | openEuler
Current arrow(arrow Storage Stack) docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Arrow is a universal columnar format and multi-language toolbox for fast data interchange and in-memory analytics. It contains a set of technologies that enable data systems to efficiently store, process, and move data.

Learn more about arrow, please visit [https://arrow.apache.org/](https://arrow.apache.org/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `arrow` docker image is consist of the version of `arrow` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[19.0.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/arrow/19.0.1/24.03-lts-sp1/Dockerfile)| arrow 19.0.1 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage

Arrow container can be used as your developement environment, please setup it first before use it.

Start a arrow instance by following command:
```bash
docker run -it --name arrow openeuler/arrow:latest
````
        
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).