# Quick reference

- The official DRBD kernel module docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# DRBD-kernel | openEuler
Current DRBD-kernel docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

DRBD, developed by LINBIT, is a software that allows RAID 1 functionality over TCP/IP and RDMA for GNU/Linux. DRBD is a block device which is designed to build high availability clusters and software defined storage by providing a virtual shared device which keeps disks in nodes synchronised using TCP/IP or RDMA. This simulates RAID 1 but avoids the use of uncommon hardware (shared SCSI buses or Fibre Channel).
This image contains the kernel side of DRBD: the `drbd` kernel module together with its `tcp`, `rdma` and `lb-tcp` transport modules, built from the upstream DRBD source. The user space utilities (`drbdadm`, `drbdsetup`, `drbdmeta`, ...) are shipped separately in the `openeuler/drbd` image, which is the `drbd-utils` package of this repository.

Learn more on [DRBD Documentation](https://linbit.com/user-guides-and-product-documentation/).

# Supported tags and respective Dockerfile links
The tag of each `drbd-kernel` docker image is consist of the version of `DRBD` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
|[9.3.4-oe2403sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/drbd-kernel/9.3.4/24.03-lts-sp4/Dockerfile) | DRBD kernel module 9.3.4 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/drbd-kernel` image from docker

	```bash
	docker pull openeuler/drbd-kernel:{Tag}
	```

- Show the DRBD modules built into the image (works on any host, it only reads the module files)

    ```
    docker run --rm openeuler/drbd-kernel:{Tag}
    ```

- Load the modules on a host which runs the kernel they were built for

    ```
    docker run --rm --privileged -v /lib/modules:/lib/modules openeuler/drbd-kernel:{Tag} modprobe drbd
    ```

    The modules are installed under `/lib/modules/<kernel release>/updates/` and are compiled against the kernel-devel shipped with this openEuler release, so the module `vermagic` has to match the kernel of the host - `modinfo` prints it. The `openeuler/drbd-kernel` image is used to verify the integration between the upstream DRBD kernel component and openEuler.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
