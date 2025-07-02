# Quick reference

- The official oozie docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# oozie | openEuler
Current oozie docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Oozie is an extensible, scalable and reliable system to define, manage, schedule, and execute complex Hadoop workloads via web services. 

For more information about oozie, please visit [http://oozie.apache.org/](http://oozie.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each oozie docker image is consist of the version of oozie and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[5.2.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/oozie/5.2.1/24.03-lts-sp1/Dockerfile)| Apache Oozie 5.2.1 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage

This image is used to verify if the upstream oozie version can be integrated with openEuler, and it has no hadoop installed.

Users should start a oozie instance by following command:
```bash
docker run -it --name oozie openeuler/oozie:latest
```
If someone needs to use the complete functions, please visit [http://oozie.apache.org/](http://oozie.apache.org/) for setting up oozie.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).