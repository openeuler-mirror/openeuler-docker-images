# Quick reference

- The official NAMD docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# NAMD | openEuler
Current NAMD docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

NAMD is a parallel, object-oriented molecular dynamics code designed for high-performance simulation of large biomolecular systems. Simulation preparation and analysis is integrated into the visualization package VMD. Visit the NAMD website for complete information and documentation.

# Supported tags and respective Dockerfile links
The tag of each `namd` docker image is consist of the version of `namd` and the version of basic image. The details are as follows

| Tag                                                                                                                        | Currently                             | Architectures |
|----------------------------------------------------------------------------------------------------------------------------|---------------------------------------|---------------|
| [3.0.1-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/namd/3.0.2/24.03-lts-sp2/Dockerfile) | NAMD 3.0.1 on openEuler 24.03-LTS-SP2 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/namd` image from docker

	```bash
	docker pull openeuler/namd:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use NAMD.
    ```
    docker run -it --rm openeuler/namd:{Tag} bash
    ```
  
- Single Process Execution

    ```
    cd /opt/namd/Linux-ARM64-g++
    /namd3 src/alanin
    ```
    This will:
    * Execute the simulation using one CPU core
    * Display progress output in terminal

- Parallel Execution Using Charm++ 

    ```
    cd /opt/namd/Linux-ARM64-g++
    ./charmrun ++local +p2 ./namd3 src/alanin
    ```
  
    This will:
    * Launch 2 parallel proecsses (`+p2`)
    * Use local communication (`++local`) on the same machine
    * Distribute computation across avaliable CPU cores

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).