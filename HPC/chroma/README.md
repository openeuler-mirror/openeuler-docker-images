# Quick reference

- The official chroma docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# chroma | openEuler
Current chroma docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Chroma is a software system for Lattice QCD (Quantum Chromodynamics) calculations developed at Jefferson Lab. It provides a framework for simulating quark and gluon interactions on a discrete spacetime lattice.

# Supported tags and respective Dockerfile links
The tag of each `chroma` docker image is consist of the version of `chroma` and the version of basic image. The details are as follows

| Tag                                                                                                                                  | Currently                                   | Architectures |
|--------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------|---------------|
| [chroma-3-44-0-oe2403sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/chroma/chroma-3-44-0/24.03-lts-sp4/Dockerfile) | chroma 3.44.0 on openEuler 24.03-LTS-SP4 | amd64, arm64  |
| [chroma-3-44-0-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/chroma/chroma-3-44-0/24.03-lts-sp3/Dockerfile) | chroma 3.44.0 on openEuler 24.03-LTS-SP3 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/chroma` image from docker

	```bash
	docker pull openeuler/chroma:{Tag}
	```

- Start a chroma instance

    ```
    docker run -it --rm openeuler/chroma:{Tag}
    ```
    The `openeuler/chroma` image is used to verify the integration between the upstream chroma version and openEuler. 

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
