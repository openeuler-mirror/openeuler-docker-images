# Quick reference
- The official deal.II docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# deal.II | openEuler
deal.II is an open-source C++ finite element library developed and maintained by a broad community from academia and industry. deal.II provides:
- Adaptive mesh refinement (h-, p-, and hp-refinement) for flexible discretization.
- MPI parallel computation for large-scale distributed simulations.
- LAPACK/BLAS linear algebra integration for efficient matrix operations.
- zlib data compression for I/O support.
- Extensive dimension-independent programming interfaces (1D, 2D, 3D).
- Auto-detection and optional integration with third-party libraries (PETSc, Trilinos, HDF5, etc.).
Learn more at [deal.II](https://github.com/dealii/dealii).

# Supported tags and respective Dockerfile links
The tag of each deal.II docker image is consist of the version of deal.II and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[9.7.1-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/dealii/9.7.1/24.03-lts-sp4/Dockerfile) | deal.II 9.7.1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[9.7.1-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/dealii/9.7.1/24.03-lts-sp3/Dockerfile) | deal.II 9.7.1 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the deal.II docker image from DockerHub:
```docker pull openeuler/dealii:{Tag}```
- Run the Docker container to launch the deal.II environment.
```docker run -it openeuler/dealii:{Tag}```
- Verify the installation inside the container:
```ls /opt/dealii/bin/ && ls /opt/dealii/lib/```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
