# Quick reference

- The official specfem3d docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# specfem3d | openEuler
Current specfem3d docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

SPECFEM3D Cartesian simulates acoustic (fluid), elastic (solid), coupled acoustic/elastic, poroelastic or seismic wave propagation in any type of conforming mesh of hexahedra (structured or unstructured). It can, for instance, model seismic waves propagating in sedimentary basins or any other regional geological model following earthquakes. It can also be used for non-destructive testing or for ocean acoustics.

Learn more on [SPECFEM3D website](https://specfem.org/).

# Supported tags and respective Dockerfile links
The tag of each `specfem3d` docker image is consist of the version of `specfem3d` and the version of basic image. The details are as follows

| Tag                                                                                                                                  | Currently                                   | Architectures |
|--------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------|---------------|
| [4.1.1-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/specfem3d/4.1.1/24.03-lts-sp3/Dockerfile) | specfem3d 4.1.1 on openEuler 24.03-LTS-SP3 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/specfem3d` image from docker

	```bash
	docker pull openeuler/specfem3d:{Tag}
	```

- Start a specfem3d instance

    ```
    docker run -it --rm openeuler/specfem3d:{Tag}
    ```
    The `openeuler/specfem3d` image is used to verify the integration between the upstream specfem3d version and openEuler. 

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).