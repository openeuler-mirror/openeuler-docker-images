# Quick reference
- The official IRVSP docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# IRVSP | openEuler
IRVSP is a Fortran package for computing irreducible representations (irreps) of the wave vectors of electronic states calculated by the DFT package VASP. It computes the irreducible representations of the little groups for space groups (including non-symmorphic and magnetic space groups) by reading the `WAVECAR` file of a VASP calculation, and outputs the `tqc.txt` and `tqc.data` files which can be uploaded to the Chinese Materials Genome Engineering (CMGE) platform to solve the elementary band representations (eBR) / atomic band representations (aBR) decompositions. The package also provides the companion tool `vasp2trace`, which computes the traces of the electronic representations and generates a `trace.txt` file for the Bilbao Crystallographic Server (BCS). IRVSP supports:
- Irreducible representation analysis for all 1651 magnetic space groups based on the character tables of the Bilbao Crystallographic Server.
- Elementary band representation / atomic band representation decomposition.
- Spin-orbit coupling (SOC) and hybrid functional calculation support.
Learn more at [IRVSP](https://github.com/zjwang11/irvsp).

# Supported tags and respective Dockerfile links
The tag of each IRVSP docker image is consist of the version of IRVSP and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[2.0-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/irvsp/2.0/24.03-lts-sp4/Dockerfile) | IRVSP 2.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the IRVSP docker image, Pull the pre-built Docker image from DockerHub:
```docker pull openeuler/irvsp:{Tag}```
- Run the Docker container to launch the IRVSP environment:
```docker run -it openeuler/irvsp:{Tag}```
- Verify the installation inside the container:
```which irvsp```
```irvsp -h```
- Use IRVSP with a VASP WAVECAR in the working directory (mount your working directory to `/workspace`):
```docker run -it -v $PWD:/workspace openeuler/irvsp:{Tag}```
```irvsp -sg xxx -nb xx xx > outir2```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).