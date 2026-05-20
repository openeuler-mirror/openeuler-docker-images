# Quick reference

- The official qmcpack docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# qmcpack | openEuler
Current qmcpack docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

QMCPACK is an open-source production-level many-body ab initio Quantum Monte Carlo code for computing the electronic structure of atoms, molecules, and solids with full performance portable GPU support. It's an acronym for Quantum Monte Carlo Package.

# Supported tags and respective Dockerfile links
The tag of each `qmcpack` docker image is consist of the version of `qmcpack` and the version of basic image. The details are as follows

| Tag                                                                                                                                  | Currently                                   | Architectures |
|--------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------|---------------|
| [4.2.0-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/qmcpack/4.2.0/24.03-lts-sp3/Dockerfile) | QMCPACK 4.2.0 on openEuler 24.03-LTS-SP3 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/qmcpack` image from docker

	```bash
	docker pull openeuler/qmcpack:{Tag}
	```

- Start a qmcpack instance

    ```
    docker run -it --rm openeuler/qmcpack:{Tag}
    ```
    
- Run a simulation with custom resources

    ```
    docker run -it --rm openeuler/qmcpack:{Tag} mpirun -np <N> bin/qmcpack <input_file.xml>
    ```
    
    The `openeuler/qmcpack` image is used to verify the integration between the upstream qmcpack version and openEuler. 

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).