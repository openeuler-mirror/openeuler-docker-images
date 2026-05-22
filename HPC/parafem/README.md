# Quick reference

- The official parafem docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# parafem | openEuler
ParaFEM is an open source parallel finite element analysis library that is documented by the text book "Programming the Finite Element Method" available in English and Simplified Chinese.


# Supported tags and respective Dockerfile links
The tag of each parafem docker image is consist of the version of parafem and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[5.0.3-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/parafem/5.0.3/24.03-lts-sp3/Dockerfile) | parafem 5.0.3 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
To pull the parafem image from the registry:

```
docker pull openeuler/parafem:{Tag}
```

To run an interactive container with the parafem environment:

```
docker run -it --rm openeuler/parafem:{Tag} /bin/bash
```

To run a ParaFEM program with MPI:

```
docker run --rm openeuler/parafem:{Tag} mpirun --allow-run-as-root -np 2 p121 p121_demo
```


# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
