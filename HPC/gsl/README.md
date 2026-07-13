# Quick reference

- The official gsl docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# gsl | openEuler
GSL - GNU Scientific Library, a collection of numerical routines for scientific computing, with CMake build support and AMPL bindings.


# Supported tags and respective Dockerfile links
The tag of each gsl docker image is consist of the version of gsl and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[20211111-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/gsl/20211111/24.03-lts-sp4/Dockerfile) | gsl 20211111 on openEuler 24.03-lts-sp4 | amd64, arm64 |
|[20211111-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/gsl/20211111/24.03-lts-sp3/Dockerfile) | gsl 20211111 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
To pull the gsl image to your local machine:

```
docker pull openeuler/gsl:{Tag}
```


To verify the installation:

```
docker run --rm openeuler/gsl:{Tag} gsl-config --version
```


# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
