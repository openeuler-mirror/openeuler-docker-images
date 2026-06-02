# Quick reference
- The official FDS docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# FDS | openEuler
FDS (Fire Dynamics Simulator) is a computational fluid dynamics (CFD) model of fire-driven fluid flow developed by NIST. FDS solves the Navier-Stokes equations appropriate for low-speed, thermally-driven flow with an emphasis on smoke and heat transport from fires using Large Eddy Simulation (LES) turbulence modeling. FDS provides:
- Low Mach number Navier-Stokes solver with LES turbulence modeling.
- MPI parallel computation and OpenMP multithreading for large-scale fire simulations.
- Thermal radiation, solid pyrolysis, combustion chemistry, soot generation and transport models.
- Sprinkler and detector activation, HVAC ventilation, and species tracking.
- HYPRE linear solver library and SUNDIALS ODE/DAE solver library integration.
- Smokeview (SMV) visualization for 3D rendering of simulation results.
Learn more at [FDS](https://github.com/firemodels/fds).
# Supported tags and respective Dockerfile links
The tag of each FDS docker image is consist of the version of FDS and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[6.11.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/fds/6.11.0/24.03-lts-sp3/Dockerfile) | FDS 6.11.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
# Usage
1. Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
2. Obtain the FDS docker image (choose one):
- Pull the pre-built Docker image from DockerHub
  - ```docker pull openeuler/fds:6.11.0-oe2403sp3```
- Or build the image locally from source
  - ```docker build -t openeuler/fds:6.11.0-oe2403sp3 6.11.0/24.03-lts-sp3/```
3. Run the Docker container to launch the FDS environment.
- ```docker run -it openeuler/fds:6.11.0-oe2403sp3```
4. Verify the installation inside the container:
- ```which fds```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).