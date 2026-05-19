# Quick reference

- The official DL_POLY docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# DL_POLY | openEuler
Current DL_POLY docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

DL_POLY is a general purpose classical molecular dynamics (MD) simulation software developed at Daresbury Laboratory since 1992. It can be built in serial form or parallel form via MPI. DL_POLY is designed to run on distributed memory parallel computers and is particularly well suited for large-scale simulations of materials.

# Supported tags and respective Dockerfile links
The tag of each `dl-poly` docker image is consist of the version of `dl-poly` and the version of basic image. The details are as follows

| Tag                                                                                                                                | Currently                                   | Architectures |
|------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------|---------------|
| [5.1.0-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/dl-poly/5.1.0/24.03-lts-sp3/Dockerfile) | DL_POLY 5.1.0 on openEuler 24.03-LTS-SP3 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/dl-poly` image from docker

	```bash
	docker pull openeuler/dl-poly:{Tag}
	```

- Start a DL_POLY instance with an interactive shell

    ```
    docker run -it --rm openeuler/dl-poly:{Tag} bash
    ```

- Run DL_POLY with your own input files

    ```
    docker run -it --rm -v /path/to/your/data:/data openeuler/dl-poly:{Tag} \
        mpirun -np 4 ./DLPOLY.Z -c /data/CONTROL -f /data/FIELD
    ```

- Run parallel simulation with multiple MPI processes

    ```
    docker run -it --rm openeuler/dl-poly:{Tag} mpirun -np 4 ./DLPOLY.Z
    ```

    Note: DL_POLY requires three input files: CONTROL, CONFIG, and FIELD.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).