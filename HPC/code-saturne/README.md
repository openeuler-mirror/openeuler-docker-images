# Quick reference
- The official code_saturne docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# code_saturne | openEuler
code_saturne is EDF's general purpose Computational Fluid Dynamics (CFD) software, developed and maintained by EDF R&D. code_saturne provides:
- Incompressible or expandable flow simulation with heat transfer and turbulence modeling.
- Dedicated modules for radiative heat transfer, combustion (gas, coal, heavy fuel oil), magneto-hydrodynamics, compressible flows, and two-phase flows (Euler-Lagrange).
- Atmospheric flow modeling with chemistry support via SSH-aerosol.
- Co-located Finite Volume approach accepting meshes with any cell type (tetrahedral, hexahedral, polyhedral, etc.).
- MPI parallel computation on distributed memory machines (Intel, AMD, ARM).
- Mesh import from CGNS, MED, GMSH, I-Deas, GAMBIT, or Simail formats.
- Post-processing output in EnSight, CGNS, and MED formats with in-situ processing via ParaView Catalyst and Melissa.
- Built-in PLE (Parallel Location and Exchange) library and MEDCoupling for tool coupling.
- FMI standard support for easy construction of associated FMUs.
Learn more at [code_saturne](https://github.com/code-saturne/code_saturne).
# Supported tags and respective Dockerfile links
The tag of each code_saturne docker image is consist of the version of code_saturne and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[8.2-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/code-saturne/8.2/24.03-lts-sp3/Dockerfile) | code_saturne 8.2 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
# Usage
1. Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
2. Obtain the code_saturne docker image (choose one):
- Pull the pre-built Docker image from DockerHub
  - ```docker pull openeuler/code-saturne:8.2-oe2403sp3```
- Or build the image locally from source
  - ```docker build -t openeuler/code-saturne:8.2-oe2403sp3 8.2/24.03-lts-sp3/```
3. Run the Docker container to launch the code_saturne environment.
- ```docker run -it openeuler/code-saturne:8.2-oe2403sp3```
4. Verify the installation inside the container:
- ```code_saturne --version```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).