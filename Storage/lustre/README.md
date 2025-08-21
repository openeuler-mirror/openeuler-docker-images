# Quick reference

- The official Lustre docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Lustre | openEuler
Current Lustre docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

The Lustre file system is an open-source, parallel file system that supports many requirements of leadership class HPC simulation environments. 

Learn more on [Lustre Documentation](https://www.lustre.org/documentation/).

# Supported tags and respective Dockerfile links
The tag of each `lustre` docker image is consist of the version of `lustre` and the version of basic image. The details are as follows

| Tag                                                                                                                                  | Currently                                 | Architectures |
|--------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|---------------|
| [2.16.55-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/lustre/2.16.55/24.03-lts-sp1/Dockerfile) | Lustre 2.16.55 on openEuler 24.03-LTS-SP1 | amd64, arm64  |
| [2.16.57-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/lustre/2.16.57/24.03-lts-sp2/Dockerfile) | Lustre 2.16.57 on openEuler 24.03-LTS-SP2 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/lustre` image from docker

	```bash
	docker pull openeuler/lustre:{Tag}
	```

- Start a lustre instance

    ```
    docker run -it --rm openeuler/lustre:{Tag}
    ```
    The `openeuler/lustre` image is used to verify the integration between the upstream lustre version and openEuler. 

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).