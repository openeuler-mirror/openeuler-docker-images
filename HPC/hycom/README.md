# Quick reference

- The official HYCOM docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# HYCOM | openEuler

[HYCOM](https://github.com/HYCOM/HYCOM-src) (HYbrid Coordinate Ocean Model) is a 3D ocean model for simulating global and regional ocean circulation. It uses a hybrid vertical coordinate system that combines isopycnic, z and sigma levels: it degenerates to z/sigma coordinates in weakly-stratified shallow waters and to isopycnic coordinates in the deep stratified ocean, balancing both accuracy and efficiency. HYCOM provides:

- MPI parallel computation for large-scale ocean simulations.
- Tide and sea ice processes.
- Data assimilation support.
- Widely used in ocean circulation, regional ocean dynamics and climate research.

Learn more at [HYCOM](https://github.com/HYCOM/HYCOM-src).

# Supported tags and respective Dockerfile links

The tag of each HYCOM docker image consists of the version of HYCOM and the version of basic image. The details are as follows:

| Tags | Currently | Architectures |
|------|-----------|---------------|
|[2.3.01-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/hycom/2.3.01/24.03-lts-sp4/Dockerfile) | HYCOM 2.3.01 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the HYCOM docker image from DockerHub:
```docker pull openeuler/hycom:{Tag}```
- Run the Docker container to launch the HYCOM environment.
```docker run -it openeuler/hycom:{Tag}```
- Verify the installation inside the container:
```which hycom```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).