# Quick reference
- The official FVCOM docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# FVCOM | openEuler
FVCOM (Finite Volume Community Ocean Model) is a three-dimensional, primitive-equation ocean model using an unstructured triangular grid and the finite-volume method. Developed by the Marine Ecosystem Dynamics Modeling Laboratory at UMASS-Dartmouth in collaboration with WHOI, FVCOM provides:
- Unstructured-grid ocean modeling with excellent coastline fitting and local refinement.
- Finite-volume discretization for mass/energy conservation and robust wet/dry treatment.
- MPI parallel computation for multi-core/multi-node ocean simulations.
- NetCDF-based input/output and a rich set of physical modules (ice, sediment, wave, water quality, biology, data assimilation).
- Support for both Cartesian and spherical coordinates.

Learn more at [FVCOM](http://fvcom.smast.umassd.edu/) and [FVCOM-GitHub](https://github.com/FVCOM-GitHub/FVCOM).

# Supported tags and respective Dockerfile links
The tag of each FVCOM docker image is consist of the version of FVCOM and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[4.4.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/fvcom/4.4.12/24.03-lts-sp4/Dockerfile) | FVCOM 4.4.12 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the FVCOM docker image from DockerHub:
```docker pull openeuler/fvcom:{Tag}```
- Run the Docker container to launch the FVCOM environment.
```docker run -it openeuler/fvcom:{Tag}```
- Verify the installation inside the container:
```which fvcom```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).