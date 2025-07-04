# Quick reference

- The official lammps docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# lammps | openEuler
Current lammps docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

LAMMPS is a classical molecular dynamics code with a focus on materials modeling. It's an acronym for Large-scale Atomic/Molecular Massively Parallel Simulator.

# Supported tags and respective Dockerfile links
The tag of each `lammps` docker image is consist of the version of `lammps` and the version of basic image. The details are as follows

| Tag                                                                                                                                  | Currently                                   | Architectures |
|--------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------|---------------|
| [29Aug2024-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/lammps/29Aug2024/24.03-lts-sp1/Dockerfile) | lammps 29Aug2024 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/lammps` image from docker

	```bash
	docker pull openeuler/lammps:{Tag}
	```

- Start a lammps instance

    ```
    docker run -it --rm openeuler/lammps:{Tag}
    ```
    The `openeuler/lammps` image is used to verify the integration between the upstream lammps version and openEuler. 

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).