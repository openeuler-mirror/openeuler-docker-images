# Quick reference

- The official QEMU docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# QEMU | openEuler
Current QEMU images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

QEMU is capable of emulating a complete machine in software without any need for hardware virtualization support. By using dynamic translation, it achieves very good performance. QEMU can also integrate with the Xen and KVM hypervisors to provide emulated hardware while allowing the hypervisor to manage the CPU. With hypervisor support, QEMU can achieve near native performance for CPUs. When QEMU emulates CPUs directly it is capable of running operating systems made for one machine (e.g. an ARMv7 board) on a different machine (e.g. an x86_64 PC board).

Read more on [QEMU documentation](https://www.qemu.org/documentation/).

# Supported tags and respective dockerfile links
The tag of each `qemu` docker image is consist of the version of `qemu` and the version of basic image. The details are as follows

| Tag                                                                                                                        | Currently                              | Architectures |
|----------------------------------------------------------------------------------------------------------------------------|----------------------------------------|---------------|
| [10.0.2-oe2403sp1](https://gitee.com/openeuler/openeuler-qemu-images/blob/master/Cloud/qemu/10.0.2/24.03-lts-sp1/qemufile) | QEMU 10.0.2 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/qemu` image from docker

	```
	docker pull openeuler/qemu:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use QEMU.
    ```
    docker run -it --rm openeuler/qemu:{Tag} bash
    ```
  
- Download a Bootable ISO
  
    Use wget to download your prefered bootable ISO image for the target architecture.
    ```
    wget https://example.com/path/to/your-os-image-aarch64.iso
    ```
    Replace this URL with your own ISO image.

- Start QEMU with the ISO(aarch64).

    Run the ISO in your container with `qemu-system-aarch64`.
    ```   
    qemu-system-aarch64 \
      -m 512M \
      -machine virt \
      -cpu cortex-a57 \
      -cdrom ./your-os-image-aarch64.iso \
      -boot d
    ```
    
    **Key options:**
    * `-m 512M:` Allocate 512M RAM.
    * `-machine:` Generic ARM64 virtual machine.
    * `-cpu cortex-a57:` ARM CPU type.
    * `-cdrom:` Path to your ISO file.
    * `-boot d:` Boot from the CD-ROM drive.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).