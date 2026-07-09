# Quick reference

- The official AMG docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# AMG | openEuler
AMG is a parallel algebraic multigrid solver for linear systems arising from problems on unstructured grids. The driver provided with AMG builds linear systems for various 3-dimensional problems. AMG is written in ISO-C. It is an SPMD code which uses MPI and OpenMP threading within MPI tasks. Parallelism is achieved by data decomposition. The driver provided with AMG achieves this decomposition by simply subdividing the grid into logical P x Q x R (in 3D) chunks of equal size.


# Supported tags and respective Dockerfile links
The tag of each AMG docker image is consist of the version of AMG and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.2-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/AMG/1.2/24.03-lts-sp4/Dockerfile) | AMG 1.2 on openEuler 24.03-lts-sp4 | amd64, arm64 |
|[1.2-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/AMG/1.2/24.03-lts-sp3/Dockerfile) | AMG 1.2 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
Run the AMG benchmark (default, single process):

```bash
docker run --rm openeuler/amg:{Tag}
```

Run with MPI (4 processes):

```bash
docker run --rm openeuler/amg:{Tag} mpirun --allow-run-as-root -np 4 amg
```

Run with custom problem size:

```bash
docker run --rm openeuler/amg:{Tag} mpirun --allow-run-as-root -np 4 amg -problem 1 -n 100 100 100 -P 2 2 1
```

Enter the container:

```bash
docker run -it --rm openeuler/amg:{Tag} /bin/bash
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
