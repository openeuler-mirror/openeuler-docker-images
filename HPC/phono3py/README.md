# Quick reference
- The official Phono3py docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# Phono3py | openEuler
Phono3py is an open-source software for phonon-phonon interaction calculations, developed and maintained by Atsushi Togo. Phono3py provides:
- Lattice thermal conductivity calculation from first-principles.
- Phonon lifetime and linewidth analysis via collision matrix solving.
- OpenMP multi-threading and MPI distributed parallel computation.
- Interfaces to various DFT codes (VASP, Quantum ESPRESSO, CRYSTAL, Abinit, TURBOMOLE).
- HDF5 file I/O for efficient storage of force constants and thermal properties.
- Random displacements method for force constants generation.
- Python API for programmatic access to phonon calculations.
Learn more at [Phono3py](https://phonopy.github.io/phono3py/).

# Supported tags and respective Dockerfile links
The tag of each Phono3py docker image is consist of the version of Phono3py and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[4.1.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/phono3py/4.1.0/24.03-lts-sp3/Dockerfile) | Phono3py 4.1.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the Phono3py docker image from DockerHub:
```docker pull openeuler/phono3py:{Tag}```
- Run the Docker container to launch the Phono3py environment.
```docker run -it openeuler/phono3py:{Tag}```
- Verify the installation inside the container:
```phono3py --version```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).