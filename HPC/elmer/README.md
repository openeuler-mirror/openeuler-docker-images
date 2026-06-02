# Quick reference
- The official Elmer docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# Elmer | openEuler
Elmer is an open-source multiphysical finite element simulation software developed and maintained by [CSC - IT Center for Science](https://www.csc.fi/). Elmer includes solvers for structural mechanics, fluid dynamics, heat transfer, electromagnetics, acoustics, and more. Elmer provides:
- MPI parallel computation and OpenMP multithreading for large-scale simulations.
- UMFPACK direct solver (bundled) and ARPACK iterative solver for linear systems.
- ElmerGrid tool for mesh generation, conversion, and partitioning.
- ElmerIce module for ice sheet and glacier dynamics simulation.
- Lua scripting extensions for custom solver configurations.
- Over 80+ physics solver modules loaded dynamically at runtime.
Learn more at [Elmer](https://github.com/ElmerCSC/elmerfem).
# Supported tags and respective Dockerfile links
The tag of each Elmer docker image is consist of the version of Elmer and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[26.2.1-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/elmer/26.2.1/24.03-lts-sp3/Dockerfile) | Elmer 26.2.1 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
# Usage
1. Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
2. Obtain the Elmer docker image (choose one):
- Pull the pre-built Docker image from DockerHub
  - ```docker pull openeuler/elmer:26.2.1-oe2403sp3```
- Or build the image locally from source
  - ```docker build -t openeuler/elmer:26.2.1-oe2403sp3 26.2.1/24.03-lts-sp3/```
3. Run the Docker container to launch the Elmer environment.
- ```docker run -it openeuler/elmer:26.2.1-oe2403sp3```
4. Verify the installation inside the container:
- ```which ElmerSolver && which ElmerGrid```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).