# Quick reference

- The official 3dslicer container image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# 3dslicer | openEuler
Current 3dslicer docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Slicer, or 3D Slicer, is a free, open source software for visualization, processing, segmentation, registration, and analysis of medical, biomedical, and other 3D images and meshes; and planning and navigating image-guided procedures.

Learn more on [3dslicer website](https://www.slicer.org/).


# Supported tags and respective Dockerfile links
The tag of each 3dslicer container image is consist of the version of 3dslicer and the version of basic image. The details are as follows

| Tags | Currently |  Architectures|
|------|-----------|---------------|
|[5.8.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/3dslicer/5.8.1/24.03-lts-sp1/Dockerfile)| 3D Slicer 5.8.1 on openEuler 24.03-LTS-SP1 | amd64, arm64 |


# Usage
- Pull the `openeuler/3dslicer` image from `hub.docker.com`
	```
	docker pull openeuler/3dslicer:{Tag}
	```
- Start a `3dslicer` instance
	```
	docker run -it --name my-3dslicer openeuler/3dslicer:{Tag}
	```
	Now, you can use 3dslicer according to [User Guide](https://slicer.readthedocs.io/en/latest/developer_guide/index.html) as
    ```
    cd Slicer-install/
    ./Slicer
    ```
    or run tests
    ```
    cd Slicer-install/
    ctest -j4
    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).