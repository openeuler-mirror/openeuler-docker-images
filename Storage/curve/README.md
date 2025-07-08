# Quick reference

- The official Curve docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Curve | openEuler
Current Curve docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Curve is a sandbox project hosted by the CNCF Foundation. It's cloud-native, high-performance, and easy to operate. Curve is an open-source distributed storage system for block and shared file storage.

# Supported tags and respective Dockerfile links
The tag of each `curve` docker image is consist of the version of `curve` and the version of basic image. The details are as follows

| Tag                                                                                                                             | Currently                              | Architectures |
|---------------------------------------------------------------------------------------------------------------------------------|----------------------------------------|---------------|
| [1.0.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/curve/1.0.0/24.03-lts-sp1/Dockerfile) | Curve 1.0.0 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/curve` image from docker

	```bash
	docker pull openeuler/curve:{Tag}
	```

- Start a curve instance

    ```
    docker run -it --rm openeuler/curve:{Tag}
    ```
    The `openeuler/curve` image is used to verify the integration between the upstream Curve version and openEuler. 

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).