# Quick reference
- The official PETSc docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# PETSc | openEuler
PETSc (Portable, Extensible Toolkit for Scientific Computation) is a high-performance scientific computing library developed by Argonne National Laboratory. PETSc provides:
- Linear equation solvers (Krylov subspace methods, direct solvers).
- Nonlinear equation solvers (Newton-type methods with line search and trust region).
- Time steppers and ODE/DAE integrators for dynamic system simulation.
- Data structures for sparse matrices, distributed arrays, and mesh management.
- MPI parallel computation for large-scale distributed processing.
- Multiple preconditioner options (ILU, ICC, SOR, AMG via HYPRE, etc.)
- Compatibility with Intel, AMD, and ARM architectures.
Learn more at [PETSc](https://github.com/petsc/petsc).

# Supported tags and respective Dockerfile links
The tag of each PETSc docker image is consist of the version of PETSc and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[3.22.4-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/petsc/3.22.4/24.03-lts-sp3/Dockerfile) | PETSc 3.22.4 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the PETSc docker image from DockerHub:
```docker pull openeuler/petsc:{Tag}```
- Run the Docker container to launch the PETSc environment.
```docker run -it openeuler/petsc:{Tag}```
- Verify the installation inside the container:
```echo $PETSC_DIR && ls $PETSC_DIR/lib/```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).