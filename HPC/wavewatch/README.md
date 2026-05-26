# Quick reference
- The official WAVEWATCH III docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# WAVEWATCH III | openEuler
WAVEWATCH III (WW3) is a full-spectral third-generation ocean wave model developed by NOAA/NCEP, solving the wave energy transport equation with source/sink terms for wind input, nonlinear wave-wave interactions, whitecapping dissipation and bottom friction. WAVEWATCH III provides:
- Multiple source term packages (ST2, ST3, ST4, ST6) for wind input and dissipation.
- MPI parallel computation for global and regional wave forecasting.
- NetCDF4/HDF5 based input/output for model data and results.
- Grid nesting, ice masking, wave-current interaction and source term offset capabilities.
- Coupled modeling support with ocean, atmosphere and ice models via ESMF/NUOPC frameworks.
- Comprehensive pre- and post-processing tools (ww3_grid, ww3_shel, ww3_outf, ww3_trck, etc.).
Learn more at [WAVEWATCH III](https://github.com/NOAA-EMC/WW3).
# Supported tags and respective Dockerfile links
The tag of each WAVEWATCH III docker image is consist of the version of WAVEWATCH III and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[6.07.1-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/wavewatch/6.07.1/24.03-lts-sp3/Dockerfile) | WAVEWATCH III 6.07.1 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
# Usage
1. Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
2. Obtain the WAVEWATCH III docker image (choose one):
- Pull the pre-built Docker image from DockerHub
  - ```docker pull openeuler/wavewatch:6.07.1-oe2403sp3```
- Or build the image locally from source
  - ```docker build -t openeuler/wavewatch:6.07.1-oe2403sp3 6.07.1/24.03-lts-sp3/```
3. Run the Docker container to launch the WAVEWATCH III environment.
- ```docker run -it openeuler/wavewatch:6.07.1-oe2403sp3```
4. Verify the installation inside the container:
- ```which ww3_shel```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).