# Quick reference

- The official ncview docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# ncview | openEuler
Ncview is a visual browser for NetCDF format files. Typically you would use ncview to get a quick and easy, push-button look at your NetCDF files. You can view simple movies of the data, view along various dimensions, take a look at the actual data values, change color maps, invert the data, and more.


# Supported tags and respective Dockerfile links
The tag of each ncview docker image is consist of the version of ncview and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[fbf1aec-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/ncview/fbf1aec/24.03-lts-sp4/Dockerfile) | ncview fbf1aec on openEuler 24.03-lts-sp4 | amd64, arm64 |
|[fbf1aec-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/ncview/fbf1aec/24.03-lts-sp3/Dockerfile) | ncview fbf1aec on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
```
docker pull openeuler/ncview:{Tag}
docker run --rm -v $(pwd):/data openeuler/ncview:{Tag} /data/sample.nc
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
