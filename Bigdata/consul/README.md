# Quick reference

- The official consul docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# Consul | openEuler
Current consul docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Consul is a distributed, highly available, and data center aware solution to connect and configure applications across dynamic, distributed infrastructure.

Learn more on [consul website](https://www.consul.io/).

# Supported tags and respective Dockerfile links
The tag of each consul docker image is consist of the version of consul and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.20.5-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/consul/1.20.5/24.03-lts-sp1/Dockerfile)| Consul 1.20.5 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
Start a consul instance by following command:
```bash
docker run -it \
    -p 8500:8500 \
    openeuler/consul:latest
    {command}
```
Please replace `{command}` by your requirements.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).