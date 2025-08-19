# Quick reference

- The official mesa docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# mesa | openEuler
Current mesa docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

The Mesa project began as an open-source implementation of the OpenGL specification - a system for rendering interactive 3D graphics.

# Supported tags and respective Dockerfile links
The tag of each `mesa` docker image is consist of the version of `mesa` and the version of basic image. The details are as follows

| Tag                                                                                                                             | Currently                              | Architectures |
|---------------------------------------------------------------------------------------------------------------------------------|----------------------------------------|---------------|
| [25.1.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/mesa/25.1.1/24.03-lts-sp1/Dockerfile) | mesa 25.1.1 on openEuler 24.03-LTS-SP1 | amd64, arm64  |
| [25.2.0-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/mesa/25.2.0/24.03-lts-sp2/Dockerfile) | mesa 25.2.0 on openEuler 24.03-LTS-SP2 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/mesa` image from docker

	```bash
	docker pull openeuler/mesa:{Tag}
	```

- Start a mesa instance

    ```
    docker run -it --rm openeuler/mesa:{Tag}
    ```
    The `openeuler/mesa` image is used to verify the integration between the upstream mesa version and openEuler. 

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).