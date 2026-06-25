# Quick reference

- The official SeisSol docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# SeisSol | openEuler
SeisSol is a scientific software for the numerical simulation of seismic wave phenomena and earthquake dynamics. It is based on the discontinuous Galerkin method combined with ADER time discretization.


# Supported tags and respective Dockerfile links
The tag of each SeisSol docker image is consist of the version of SeisSol and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[202103.Sumatra-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/seissol/202103.Sumatra/24.03-lts-sp3/Dockerfile) | seissol 202103.Sumatra on openEuler 24.03-LTS-SP3 | amd64, arm64 |
|[1.3.2-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/seissol/1.3.2/24.03-lts-sp3/Dockerfile) | SeisSol 1.3.2 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
Run a SeisSol simulation with mpirun:
```
docker run --rm -v /path/to/input:/data openeuler/seissol:{Tag} SeisSol input.par
```

Run with a specific number of MPI processes:
```
docker run --rm -v /path/to/input:/data openeuler/seissol:{Tag} -np 4 SeisSol input.par
```


# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).