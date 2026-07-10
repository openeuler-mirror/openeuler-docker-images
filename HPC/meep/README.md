# Quick reference
- The official Meep docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# Meep | openEuler
Meep is a free and open-source finite-difference time-domain (FDTD) electromagnetic simulation software developed and maintained by the NanoComp team. Meep provides:
- FDTD simulation in 1D, 2D, 3D, and cylindrical coordinates.
- MPI distributed-memory parallelism for large-scale simulations.
- Perfectly matched layer (PML) absorbing boundaries and Bloch-periodic boundary conditions.
- Dispersive ε(ω) and μ(ω), nonlinear (Kerr & Pockels), anisotropic, and gyrotropic material modeling.
- Subpixel smoothing for improved accuracy and shape optimization.
- Frequency-domain solver and eigensolver for resonant mode analysis.
- Adjoint solver for inverse design and topology optimization.
- Python, Scheme, and C++ programming interfaces.
- Precompiled binary packages via Conda for rapid deployment.
Learn more at [Meep](https://github.com/NanoComp/meep).

# Supported tags and respective Dockerfile links
The tag of each Meep docker image is consist of the version of Meep and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[1.33.0-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/meep/1.33.0/24.03-lts-sp4/Dockerfile) | Meep 1.33.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[1.33.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/meep/1.33.0/24.03-lts-sp3/Dockerfile) | Meep 1.33.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the Meep docker image from DockerHub:
```docker pull openeuler/meep:{Tag}```
- Run the Docker container to launch the Meep environment.
```docker run -it openeuler/meep:{Tag}```
- Verify the installation inside the container:
```meep --version```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
