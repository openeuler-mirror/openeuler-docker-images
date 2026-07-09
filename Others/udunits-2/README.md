# Quick reference

- The official UDUNITS-2 docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# UDUNITS-2 | openEuler
The UDUNITS package supports units of physical quantities. Its C library provides for arithmetic manipulation of units and for conversion of numeric values between compatible units. The package contains an extensive unit database, which is in XML format and user-extendable. The package also contains a command-line utility for investigating units and converting values.

Learn more on [UDUNITS | NSF Unidata](https://www.unidata.ucar.edu/software/udunits).

# Supported tags and respective Dockerfile links
The tag of each UDUNITS-2 docker image is consist of the version of UDUNITS-2 and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[2.2.28-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/udunits-2/2.2.28/24.03-lts-sp4/Dockerfile) | UDUNITS-2 2.2.28 on openEuler 24.03-lts-sp4 | amd64, arm64 |
|[2.2.28-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/udunits-2/2.2.28/24.03-lts-sp3/Dockerfile) | UDUNITS-2 2.2.28 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
In this usage, users can select the UDUNITS-2 image they need.

- Pull the UDUNITS-2 image from docker

```bash
docker pull openeuler/udunits-2:{Tag}
```

- Start a container to convert units interactively

```bash
docker run -it --rm openeuler/udunits-2:{Tag} udunits2
```

- Convert a specific value between units

```bash
docker run --rm openeuler/udunits-2:{Tag} udunits2 -H km -W m
```

- Get the definition of a unit

```bash
docker run --rm openeuler/udunits-2:{Tag} udunits2 -A -H meter
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
