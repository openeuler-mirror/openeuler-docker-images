# Quick reference
- The official COPASI docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# COPASI | openEuler
COPASI (Complex Pathway Simulator) is a software application for simulation and analysis of biochemical networks and their dynamics. It supports models in the SBML standard and can simulate their behavior using ODEs, SDEs, or Gillespie's stochastic simulation algorithm. COPASI provides:
- Deterministic (ODE) and stochastic (Gillespie, SDE) time course simulations.
- Steady-state and metabolic control analysis.
- Parameter estimation and optimization.
- Sensitivity analysis and cross-sections.
- Scan tasks for systematic parameter exploration.
- Arbitrary discrete events in simulations.
- SBML (Level 3 Version 2), SED-ML, and COMBINE archive support.
- C, Python (basiCO), and R (CoRC) language bindings.
Learn more at [COPASI](https://github.com/copasi/COPASI).
# Supported tags and respective Dockerfile links
The tag of each COPASI docker image is consist of the version of COPASI and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[4.46.300-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/copasi/4.46.300/24.03-lts-sp3/Dockerfile) | COPASI 4.46 (Build 300) on openEuler 24.03-LTS-SP3 | amd64, arm64 |
# Usage
1. Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
2. Obtain the COPASI docker image (choose one):
- Pull the pre-built Docker image from DockerHub
  - ```docker pull openeuler/copasi:4.46-oe2403sp3```
- Or build the image locally from source
  - ```docker build -t openeuler/copasi:4.46-oe2403sp3 4.46/24.03-lts-sp3/```
3. Run the Docker container to launch the COPASI environment.
- ```docker run -it openeuler/copasi:4.46-oe2403sp3```
4. Verify the installation inside the container:
- ```CopasiSE --help```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler-docker-images).