# Quick reference
 - The official Palabos docker image.
 - Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
 - Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
 # Palabos | openEuler
 Palabos is a free and open-source lattice Boltzmann method (LBM) computational fluid dynamics (CFD) solver developed and maintained by the University of Geneva (UNIGE) team. Palabos provides:
 - MPI distributed-memory parallelism for large-scale simulations.
 - Free surface flow modeling with interface tracking.
 - Particle and bubble dynamics in multiphase flows.
 - Porous media flow simulation at the pore-scale level.
 - Adaptive mesh refinement for flexible discretization.
 - HDF5 output support for large-scale data I/O.
 - C++, Python, and Java programming interfaces.
 - VTK output integration for ParaView visualization.
 Learn more at [Palabos](https://gitlab.com/unigespc/palabos).
 # Supported tags and respective Dockerfile links
 The tag of each Palabos docker image is consist of the version of Palabos and the version of basic image. The details are as follows:
 | Tags | Currently | Architectures |
 |------|-----------|---------------|
 |[v2.3.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/palabos/v2.3.0/24.03-lts-sp3/Dockerfile) | Palabos v2.3.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
 # Usage
 1. Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
 2. Obtain the Palabos docker image (choose one):
 - Pull the pre-built Docker image from DockerHub
   - ```docker pull openeuler/palabos:v2.3.0-oe2403sp3```
 - Or build the image locally from source
   - ```docker build -t openeuler/palabos:v2.3.0-oe2403sp3 v2.3.0/24.03-lts-sp3/```
 3. Run the Docker container to launch the Palabos environment.
 - ```docker run -it openeuler/palabos:v2.3.0-oe2403sp3```
 4. Verify the installation inside the container:
 - Compile and run the cavity2d showcase example:
   - ```cd /opt/palabos/examples/showCases/cavity2d/build && cmake .. && make && cd .. && ./cavity2d```
 - Run with MPI parallel execution:
   - ```mpirun -np 4 ./cavity2d```
 # Question and answering
 If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).