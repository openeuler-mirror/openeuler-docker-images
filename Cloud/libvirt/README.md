# Quick reference

- The official Libvirt docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Libvirt | openEuler
Current Libvirt docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Libvirt provides a portable, long term stable C API for managing the
virtualization technologies provided by many operating systems. It
includes support for QEMU, KVM, Xen, LXC, bhyve, Virtuozzo, VMware
vCenter and ESX, VMware Desktop, Hyper-V, VirtualBox and the POWER
Hypervisor.

Learn more about Libvirt on [libvirt Website](https://libvirt.org)⁠.

# Supported tags and respective Dockerfile links
The tag of each `libvirt` docker image is consist of the version of `libvirt` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[11.3.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/libvirt/11.3.0/24.03-lts-sp1/Dockerfile)| Libvirt 11.3.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/libvirt` image from docker

	```bash
	docker pull openeuler/libvirt:{Tag}
	```

- Start a libvirt instance

    ```
    docker run -it --rm openeuler/libvirt:{Tag}
    ```
    The `openeuler/libvirt` image is used to verify the integration between the upstream libvirt version and openEuler. 

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).