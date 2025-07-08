# Quick reference

- The official Ceph docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Ceph | openEuler
Current Ceph docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Ceph is a distributed object, block, and file storage platform.

Learn more on [Ceph Documentation](https://docs.ceph.com/en/latest/start/).

# Supported tags and respective Dockerfile links
The tag of each `ceph` docker image is consist of the version of `ceph` and the version of basic image. The details are as follows

| Tag                                                                                                                              | Currently                              | Architectures |
|----------------------------------------------------------------------------------------------------------------------------------|----------------------------------------|---------------|
| [20.3.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/ceph/20.3.0/24.03-lts-sp1/Dockerfile) | Ceph 20.3.0 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/ceph` image from docker

	```bash
	docker pull openeuler/ceph:{Tag}
	```

- Start a ceph instance

    ```
    docker run -it --rm openeuler/ceph:{Tag}
    ```
    The `openeuler/ceph` image is used to verify the integration between the upstream ceph version and openEuler. 

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).