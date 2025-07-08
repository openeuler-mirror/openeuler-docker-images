# Quick reference

- The official DRBD-utils docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# DRBD-utils | openEuler
Current DRBD-utils docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

DRBD, developed by LINBIT, is a software that allows RAID 1 functionality over TCP/IP and RDMA for GNU/Linux. DRBD is a block device which is designed to build high availability clusters and software defined storage by providing a virtual shared device which keeps disks in nodes synchronised using TCP/IP or RDMA. This simulates RAID 1 but avoids the use of uncommon hardware (shared SCSI buses or Fibre Channel).
This image contains the user space utilities for DRBD.

Learn more on [DRBD Documentation](https://linbit.com/user-guides-and-product-documentation/).

# Supported tags and respective Dockerfile links
The tag of each `drbd-utils` docker image is consist of the version of `drbd-utils` and the version of basic image. The details are as follows

| Tag                                                                                                                                    | Currently                                    | Architectures |
|----------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------|---------------|
| [9.31.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/drbd-utils/9.31.0/24.03-lts-sp1/Dockerfile) | DRBD-utils 9.31.0 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/drbd-utils` image from docker

	```bash
	docker pull openeuler/drbd-utils:{Tag}
	```

- Start a drbd-utils instance

    ```
    docker run -it --rm openeuler/drbd-utils:{Tag}
    ```
    The `openeuler/drbd-utils` image is used to verify the integration between the upstream DRBD-utils version and openEuler. 

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).