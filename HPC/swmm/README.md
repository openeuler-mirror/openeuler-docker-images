# Quick reference
- The official SWMM docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# SWMM | openEuler
SWMM (Stormwater Management Model) is a dynamic hydrology-hydraulic water quality simulation model developed and maintained by US EPA. SWMM provides:
- Dynamic rainfall-runoff simulation for single event or long-term continuous analysis.
- Hydraulic flow routing with kinematic wave and dynamic wave options.
- Water quality simulation for pollutant buildup, washoff, and transport.
- Low Impact Development (LID) controls modeling for green infrastructure.
- Street inlet capture analysis using HEC-22 equations or custom curves.
- Variable speed pump modeling with pump affinity laws.
- Storage curve options with pre-defined analytical shapes (cylinders, paraboloids, cones, pyramids).
- Public domain license allowing unrestricted use and modification.
Learn more at [SWMM](https://github.com/USEPA/Stormwater-Management-Model).

# Supported tags and respective Dockerfile links
The tag of each SWMM docker image is consist of the version of SWMM and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[5.2.4-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/swmm/5.2.4/24.03-lts-sp4/Dockerfile) | SWMM 5.2.4 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[5.2.4-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/swmm/5.2.4/24.03-lts-sp3/Dockerfile) | SWMM 5.2.4 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the SWMM docker image from DockerHub:
```docker pull openeuler/swmm:{Tag}```
- Run the Docker container to launch the SWMM environment.
```docker run -it openeuler/swmm:{Tag}```
- Verify the installation inside the container:
```ls /opt/swmm/build/install/bin/```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
