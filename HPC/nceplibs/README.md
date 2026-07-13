# Quick reference

- The official NCEPLIBS docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# NCEPLIBS | openEuler
NCEPLIBS is a collection of libraries commonly known as NCEPLIBS that are required for several NCEP applications e.g. UFS, GSI, UPP, etc. It provides various libraries for meteorological data processing, including GRIB format encoding/decoding, binary I/O, spectral transforms, interpolation, and more.

Learn more on [NCEPLIBS Documentation](https://noaa-emc.github.io/NCEPLIBS/).

# Supported tags and respective Dockerfile links
The tag of each NCEPLIBS docker image is consist of the version of NCEPLIBS and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.4.0-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/nceplibs/1.4.0/24.03-lts-sp4/Dockerfile) | NCEPLIBS 1.4.0 on openEuler 24.03-lts-sp4 | amd64, arm64 |
|[1.4.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/nceplibs/1.4.0/24.03-lts-sp3/Dockerfile) | NCEPLIBS 1.4.0 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
In this docker image, NCEPLIBS is installed under `/opt/nceplibs`. You can use this image as a base for building HPC applications that depend on NCEPLIBS.

```bash
docker pull openeuler/NCEPLIBS:{Tag}
docker run -it openeuler/NCEPLIBS:{Tag} bash
```

To use NCEPLIBS in your CMake project:

```bash
cmake -DCMAKE_PREFIX_PATH=/opt/nceplibs <your-project-source>
make -j$(nproc)
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
