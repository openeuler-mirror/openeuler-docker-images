# Quick reference
- The official OpenMolcas docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# OpenMolcas | openEuler
OpenMolcas is a quantum chemistry software package with the key feature of the multiconfigurational approach to the electronic structure. It provides methods like CASSCF (Complete Active Space Self-Consistent Field) and CASPT2 (Complete Active Space Second-Order Perturbation Theory) for multi-reference electronic structure calculations. OpenMolcas provides:
- CASSCF and CASPT2 for multi-reference electronic structure calculations.
- Geometry optimization and energy calculations.
- Spectral properties and response properties calculation.
- RASSCF, RASPT2, and MS-CASPT2 variants.
- Single-state and multi-state dynamics simulations.
- Integration with external libraries for extended functionality.
Learn more at [OpenMolcas](https://gitlab.com/Molcas/OpenMolcas).

# Supported tags and respective Dockerfile links
The tag of each OpenMolcas docker image is consist of the version of OpenMolcas and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[26.02-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/openmolcas/26.02/24.03-lts-sp3/Dockerfile) | OpenMolcas 26.02 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the OpenMolcas docker image from DockerHub:
```docker pull openeuler/openmolcas:{Tag}```
- Run the Docker container to launch the OpenMolcas environment.
```docker run -it openeuler/openmolcas:{Tag}```
- Verify the installation inside the container:
```pymolcas --help```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).