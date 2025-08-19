# Quick reference

- The official mongoose docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# mongoose | openEuler
Current mongoose docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Mongoose is a MongoDB object modeling tool designed to work in an asynchronous environment. 

For more information about mongoose, please visit [https://mongoosejs.com/](https://mongoosejs.com/).

# Supported tags and respective Dockerfile links
The tag of each mongoose docker image is consist of the version of mongoose and the version of basic image. The details are as follows

| Tags                                                                                                                            | Currently                                | Architectures |
|---------------------------------------------------------------------------------------------------------------------------------|------------------------------------------|---------------|
| [5.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/mongoose/5.1/24.03-lts-sp1/Dockerfile)   | Mongoose 5.1 on openEuler 24.03-LTS-SP1  | amd64, arm64  |
| [7.18-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/mongoose/7.18/24.03-lts-sp2/Dockerfile) | Mongoose 7.18 on openEuler 24.03-LTS-SP2 | amd64, arm64  |

# Usage

This image is used to verify if the upstream mongoose version can be integrated with openEuler, users should sutup mongoose by themselves.

Users should start a mongoose instance by following command:
```bash
docker run -it --name mongoose openeuler/mongoose:latest
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).