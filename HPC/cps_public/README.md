# Quick reference

- The official CPS_public docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# CPS_public | openEuler
The CPS consists of code to build a library which can be statically linked to your code to create an executable. In addition there are tests and documentation. CPS has optimized codes for QCDOC, IBM Blue Gene machines, and builds for scalar machines or parallel machines with QMP.


# Supported tags and respective Dockerfile links
The tag of each CPS_public docker image is consist of the version of CPS_public and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[5_2_5-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/cps_public/5_2_5/24.03-lts-sp4/Dockerfile) | CPS_public 5_2_5 on openEuler 24.03-lts-sp4 | amd64, arm64 |
|[5_2_5-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/cps_public/5_2_5/24.03-lts-sp3/Dockerfile) | CPS_public 5_2_5 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
```
docker pull openeuler/cps_public:{Tag}
docker run -it --rm -v $(pwd):/workspace openeuler/cps_public:{Tag} bash
```

Inside the container, compile your application against the CPS library:
```
g++ -I/usr/local/include/cps -L/usr/local/lib -lcps your_app.cpp -o your_app
```


# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
