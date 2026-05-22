# Quick reference

- The official grib_api docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# grib_api | openEuler
GRIB API is the encoding/decoding software for GRIB edition 1 and 2 developed at ECMWF.


# Supported tags and respective Dockerfile links
The tag of each grib_api docker image is consist of the version of grib_api and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.21.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/grib_api/1.21.0/24.03-lts-sp3/Dockerfile) | grib_api 1.21.0 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
To pull the grib_api image:

```
docker pull openeuler/grib_api:{Tag}
```

To run the grib_api container and use the command-line tools:

```
docker run --rm openeuler/grib_api:{Tag} grib_ls -h
```

Example: inspecting a GRIB file mounted into the container:

```
docker run --rm -v /path/to/data:/data openeuler/grib_api:{Tag} grib_ls /data/sample.grib
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
