# Quick reference

- The official QDK docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# QDK | openEuler
QDK is used to build QPKG files/applications for QNAP Turbo NAS. A QPKG file makes it easy for anyone to install and remove packages. It also gives a package maintainer almost total control on how the package is installed on the NAS. The major design goal of QDK is to make it easy for the package maintainer to create simple QPKG files and at the same time also support more advanced packages. QDK started out as a simple modification of the first official release of the QPKG SDK, but now supersedes it. It includes many new features like architecture check at installation, support for digital signatures, different compression algorithms, a comprehensive option to check that other required QPKG packages are installed (or that conflicting packages are not installed), and a powerful build script.


# Supported tags and respective Dockerfile links
The tag of each QDK docker image is consist of the version of QDK and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[2.5.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/qdk/2.5.0/24.03-lts-sp3/Dockerfile) | QDK 2.5.0 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
Run the container and use qbuild to build a QPKG package:
```
docker run --rm -v $(pwd):/workspace openeuler/qdk:{Tag} qbuild
```

Show qbuild help:
```
docker run --rm openeuler/qdk:{Tag} qbuild --help
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
