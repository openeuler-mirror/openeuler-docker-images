# Quick reference

- The official scalapack docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# scalapack | openEuler
ScaLAPACK, or Scalable LAPACK, is a library of high performance linear algebra routines for distributed memory computers supporting MPI.

Learn more on [ScaLAPACK — Scalable Linear Algebra PACKage](https://netlib.org/scalapack/).


# Supported tags and respective Dockerfile links
The tag of each scalapack docker image is consist of the version of scalapack and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[2.2.3-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/scalapack/2.2.3/24.03-lts-sp4/Dockerfile) | scalapack 2.2.3 on openEuler 24.03-lts-sp4 | amd64, arm64 |
|[2.2.3-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/scalapack/2.2.3/24.03-lts-sp3/Dockerfile) | scalapack 2.2.3 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
```
docker pull openeuler/scalapack:{Tag}
docker run --rm openeuler/scalapack:{Tag} mpirun --allow-run-as-root -np 4 /path/to/your_mpi_program
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
