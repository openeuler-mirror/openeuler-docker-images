# Quick reference

- The official Nemo docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Nemo | openEuler
Current Nemo docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Nemo is a free and open-source software and official file manager of the Cinnamon desktop environment. It is a fork of GNOME Files (formerly named Nautilus).

# Supported tags and respective Dockerfile links
The tag of each `nemo` docker image is consist of the version of `nemo` and the version of basic image. The details are as follows

| Tag                                                                                                                        | Currently                             | Architectures |
|----------------------------------------------------------------------------------------------------------------------------|---------------------------------------|---------------|
| [6.4.5-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/nemo/6.4.5/24.03-lts-sp1/Dockerfile) | Nemo 6.4.5 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/nemo` image from docker

	```bash
	docker pull openeuler/nemo:{Tag}
	```

- Start a nemo instance

    ```
    docker run -it --rm openeuler/nemo:{Tag}
    ```
    The `openeuler/nemo` image is used to verify the integration between the upstream nemo version and openEuler. 

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).