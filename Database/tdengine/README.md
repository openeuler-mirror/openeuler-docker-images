# Quick reference

- The official tdengine docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# tdengine | openEuler
Current tdengine docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Tdengine is a MongoDB object modeling tool designed to work in an asynchronous environment. 

For more information about tdengine, please visit [https://tdengine.com/](https://tdengine.com/).

# Supported tags and respective Dockerfile links
The tag of each tdengine docker image is consist of the version of tdengine and the version of basic image. The details are as follows

| Tags                                                                                                                                   | Currently                                   | Architectures |
|----------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------|---------------|
| [3.3.6.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/tdengine/3.3.6.0/24.03-lts-sp1/Dockerfile) | tdengine 3.3.6.0 on openEuler 24.03-LTS-SP1 | amd64, arm64  |
| [3.3.7.3-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/tdengine/3.3.7.3/24.03-lts-sp2/Dockerfile) | tdengine 3.3.7.3 on openEuler 24.03-LTS-SP2 | amd64, arm64  |

# Usage

This image is used to verify if the upstream tdengine version can be integrated with openEuler, users should sutup tdengine by themselves.

Users should start a tdengine instance by following command:
```bash
docker run -it --name tdengine openeuler/tdengine:latest
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).