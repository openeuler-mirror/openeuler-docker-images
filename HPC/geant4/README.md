# Quick reference

- The official geant4 docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# geant4 | openEuler
Current geant4 docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Geant4 is a toolkit for the simulation of the passage of particles through matter. Its areas of application include high energy, nuclear and accelerator physics, as well as studies in medical and space science.

# Supported tags and respective Dockerfile links
The tag of each `geant4` docker image is consist of the version of `geant4` and the version of basic image. The details are as follows

| Tag                                                                                                                                  | Currently                                   | Architectures |
|--------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------|---------------|
| [11.4.1-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/geant4/11.4.1/24.03-lts-sp3/Dockerfile) | geant4 11.4.1 on openEuler 24.03-LTS-SP3 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/geant4` image from docker

	```bash
	docker pull openeuler/geant4:{Tag}
	```

- Start a geant4 instance

    ```
    docker run -it --rm openeuler/geant4:{Tag}
    ```
    The `openeuler/geant4` image is used to verify the integration between the upstream geant4 version and openEuler. 

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).