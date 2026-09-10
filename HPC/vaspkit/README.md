# Quick reference
- The official VASPKIT docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# VASPKIT | openEuler
VASPKIT is a command-line and interactive program for pre- and post-processing of the VASP (Vienna Ab initio Simulation Package) code, aiming to facilitate high-throughput first-principles calculations. VASPKIT provides:
- Pre-processing utilities to prepare VASP input files (POSCAR, KPOINTS, POTCAR, INCAR).
- Post-processing utilities to analyze VASP output files (band structure, DOS, charge density, optical, elastic, etc.).
- Interactive bash-like command interface for convenient usage.
Learn more at [VASPKIT](https://vaspkit.com).

# Supported tags and respective Dockerfile links
The tag of each VASPKIT docker image is consist of the version of VASPKIT and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[0.52-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/vaspkit/0.52/24.03-lts-sp4/Dockerfile) | VASPKIT 0.52 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Docker for Linux containers if on Windows.
- Obtain the VASPKIT docker image from DockerHub:
```docker pull openeuler/vaspkit:{Tag}```
- Run the Docker container to launch the VASPKIT environment.
```docker run -it openeuler/vaspkit:{Tag}```
- Verify the installation inside the container:
```vaspkit --help```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).