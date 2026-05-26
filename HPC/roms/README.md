# Quick reference
- The official ROMS docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# ROMS | openEuler
ROMS is a free-surface, hydrostatic, primitive equation ocean model using stretched terrain-following vertical coordinates and orthogonal curvilinear horizontal coordinates on an Arakawa C-grid, developed by The ROMS Group. ROMS provides:
- Nonlinear, tangent linear, representer and adjoint dynamical kernel solvers.
- MPI parallel computation for large-scale regional ocean simulations.
- NetCDF4/HDF5 based input/output for model data and results.
- Sea ice, sediment transport, vegetation and biology process modules.
- Coupled modeling support with ESMF, WRF and COAMPS frameworks.
- Multiple idealized and realistic test cases (e.g. UPWELLING, BENCHMARK, CANYON).
Learn more at [ROMS](https://github.com/myroms/roms).
# Supported tags and respective Dockerfile links
The tag of each ROMS docker image is consist of the version of ROMS and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[4.2-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/roms/4.2/24.03-lts-sp3/Dockerfile) | ROMS 4.2 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
# Usage
1. Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
2. Obtain the ROMS docker image (choose one):
- Pull the pre-built Docker image from DockerHub
  - ```docker pull openeuler/roms:4.2-oe2403sp3```
- Or build the image locally from source
  - ```docker build -t openeuler/roms:4.2-oe2403sp3 4.2/24.03-lts-sp3/```
3. Run the Docker container to launch the ROMS environment.
- ```docker run -it openeuler/roms:4.2-oe2403sp3```
4. Verify the installation inside the container:
- ```which roms```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).