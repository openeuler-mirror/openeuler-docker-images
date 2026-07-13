# Quick reference
- The official Spack docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# Spack | openEuler
Spack is a multi-platform package manager that builds and installs multiple versions and configurations of software. It works on Linux, macOS, Windows, and many supercomputers. Spack is non-destructive: installing a new version does not break existing installations, so many configurations can coexist. It provides:
- A simple "spec" syntax to specify versions and configuration options.
- Package files written in pure Python, allowing a single script for many different builds.
- Non-destructive installs so many configurations can coexist.
- Support for multiple platforms including Linux, macOS, and many supercomputers.
Learn more at [Spack](https://spack.io/).

# Supported tags and respective Dockerfile links
The tag of each Spack docker image is consist of the version of Spack and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[1.1.1-oe2403sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/spack/1.1.1/24.03-lts-sp4/Dockerfile)| spack 1.1.1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[1.1.1-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/spack/1.1.1/24.03-lts-sp3/Dockerfile)| spack 1.1.1 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the Spack docker image from DockerHub:
```docker pull openeuler/spack:{Tag}```
- Run the Docker container to launch the Spack environment.
```docker run -it openeuler/spack:{Tag}```
- Verify the installation inside the container:
```spack --version```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
