# Quick reference
- The official Chaste docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# Chaste | openEuler
Chaste (Cancer Heart And Soft Tissue Environment) is an open-source computational biology platform for cancer, heart, and soft tissue simulation, developed and maintained by the Chaste project team. Chaste provides:
- Cell-based simulation for modeling individual cell behaviors and tissue morphogenesis.
- Cardiac electrophysiology modeling for simulating heart electrical activity and action potentials.
- Continuum mechanics solving for solid mechanics, fluid mechanics, and fluid-solid interaction problems.
- PDE and ODE solvers powered by SUNDIALS and PETSc for efficient numerical computation.
- Mesh generation and processing for complex geometric domains.
- Lung simulation for modeling respiratory physiology and airflow dynamics.
- MPI parallel computation via PETSc for large-scale distributed simulations.
- VTK visualization output for scientific data rendering and analysis.
- PyChaste Python interface for scripting and rapid prototyping.
- Crypt simulation for intestinal epithelial tissue modeling.
Learn more at [Chaste](https://chaste.github.io).
# Supported tags and respective Dockerfile links
The tag of each Chaste docker image is consist of the version of Chaste and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[2026.1-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/chaste/2026.1/24.03-lts-sp3/Dockerfile) | Chaste 2026.1 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
# Usage
1. Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
2. Obtain the Chaste docker image (choose one):
- Pull the pre-built Docker image from DockerHub
  - ```docker pull openeuler/chaste:2026.1-oe2403sp3```
- Or build the image locally from source
  - ```docker build -t openeuler/chaste:2026.1-oe2403sp3 2026.1/24.03-lts-sp3/```
3. Run the Docker container to launch the Chaste environment.
- ```docker run -it openeuler/chaste:2026.1-oe2403sp3```
4. Verify the installation inside the container:
- ```ls /opt/chaste/bin/ && ls /opt/chaste/lib/```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).