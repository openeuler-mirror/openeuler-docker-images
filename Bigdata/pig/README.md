# Quick reference

- The official pig docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Apache Pig | openEuler
Current pig docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Pig is a platform for analyzing large data sets. Pig's language, Pig Latin, lets you specify a sequence of data transformations such as merging data sets, filtering them, and applying functions to records or groups of records. Pig comes with many built-in functions but you can also create your own user-defined functions to do special-purpose processing.

For more information about pig, please visit [https://pig.apache.org/](https://pig.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each pig docker image is consist of the version of pig and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[0.17.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/pig/0.17.0/24.03-lts-sp1/Dockerfile)| Apache Pig 0.17.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage

Users should start a pig instance by following command:
```bash
docker run -it --name pig openeuler/pig:latest
```
If someone needs to use the complete functions, please visit [http://pig.apache.org/](http://pig.apache.org/) for setting up pig.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).