# Quick reference

- The official fbthrift docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# fbthrift | openEuler
fbthrift is Facebook's branch of Apache Thrift, including a new C++ server. It is a high-performance serialization framework and RPC (Remote Procedure Call) framework that enables efficient cross-language service communication. fbthrift provides an interface definition language (IDL) to define service interfaces and data structures, then uses a code generation engine to build client and server communication code in different programming languages, allowing applications written in different languages to communicate seamlessly.


# Supported tags and respective Dockerfile links
The tag of each fbthrift docker image is consist of the version of fbthrift and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[2026.06.22.00-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/fbthrift/2026.06.22.00/24.03-lts-sp3/Dockerfile) | fbthrift 2026.06.22.00 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
|[2026.05.18.00-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/fbthrift/2026.05.18.00/24.03-lts-sp3/Dockerfile) | fbthrift 2026.05.18.00 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
## Quick Start

### Running the container

```bash
docker run -d --name fbthrift openeuler/fbthrift:{Tag}
```

### Using the Thrift compiler

```bash
# Enter the container
docker exec -it fbthrift /bin/bash

# Compile IDL files using thrift1
thrift1 --gen cpp2 example.thrift
thrift1 --gen java example.thrift
thrift1 --gen py example.thrift
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).