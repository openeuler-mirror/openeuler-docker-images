# Quick reference

- The official tengine docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# Tengine | openEuler
Current tengine docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Tengine is a web server originated by Taobao, the largest e-commerce website in Asia. It is based on the Nginx HTTP server and has many advanced features. 

For more information about tengine, please visit [https://tengine.taobao.org/](https://tengine.taobao.org/).

# Supported tags and respective Dockerfile links
The tag of each tengine docker image is consist of the version of tengine and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[2.4.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/tengine/2.4.1/24.03-lts-sp1/Dockerfile)| tengine 2.4.1 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage

This image is used to verify if the upstream tengine version can be integrated with openEuler, users should sutup tengine by themselves.

Users should start a tengine instance by following command:
```bash
docker run -it --name tengine openeuler/tengine:latest
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).