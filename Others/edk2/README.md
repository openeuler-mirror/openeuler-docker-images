# Quick reference

- The official EDK II docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# EDK II | openEuler
Current EDK II docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

EDK II is a modern, feature-rich, cross-platform firmware development environment for the UEFI and PI specifications. EDK II is open source, using a BSD+Patent.

Learn more about EDK II on [EDK II Website](https://github.com/tianocore/tianocore.github.io/wiki/EDK-II-Documents)⁠.

# Supported tags and respective Dockerfile links
The tag of each `edk2` docker image is consist of the version of `edk2` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[202502-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/edk2/202502/24.03-lts-sp1/Dockerfile)| EDK II 202502 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/edk2` image from docker

	```bash
	docker pull openeuler/edk2:{Tag}
	```

- Step 1: Start a EDK II container instance

    By default, start the container with an interactive shell.
    ```
	 docker run -it --privileged --device /dev/kvm --rm openeuler/edk2:{Tag}
    ```
  
    * `--privileged`: Grants the container elevated privileges, including access to all host devices and kernel capabilities. Required for QEMU/KVM acceleration.
    * `--device /dev/kvm`: Passes the host's /dev/kvm device to the container, allowing QEMU to use hardware-assisted virtualization (faster emulation).
    
- Step 2: Initialize EDK II Environment
    
    This is a test environment: AArch64 (ARM 64-bit) on OpenEuler with QEMU
    ```
    source edksetup.sh
    ```
  
    * Sets up the EDK II build environment by configuring necessary paths (e.g., WORKSPACE, EDK_TOOLS_PATH).
    * Prepares Python scripts and toolchain variables for subsequent builds.

- Step 3: Configure Build Target

    Modifications:
    ```
    TARGET_ARCH = AArch64
    TOOL_CHAIN_TAG = GCC5
    ```
  
    * AArch64 with GCC5 toolchain (Linux). For x86_64 hosts, set TARGET_ARCH=X64.
    * Ensures the build system generates ARM 64-bit binaries using GCC.

- Step 4: Build HelloWorld UEFI Application

    The following example demonstrates how to build and use `HelloWorld`.
    ```
    build -p MdeModulePkg/MdeModulePkg.dsc \
      -m MdeModulePkg/Application/HelloWorld/HelloWorld.inf \
      -a AARCH64
    ```
  
    * Compiles the HelloWorld UEFI application from the EDK II MdeModulePkg.
    * Outputs:
       * Binary: /opt/edk2/Build/MdeModule/DEBUG_GCC5/AARCH64/HelloWorld.efi
       * Debug files and logs in the same directory.

- Step 5: Install QEMU and Dependencies
    ```
    dnf install -y qemu-system-aarch64 wget 
    ```
  
    * Installs QEMU for AArch64 emulation and wget to download UEFI firmware.
    * Required to emulate an ARM-based UEFI environment.
    
    Download UEFI firmware:
    ```
    wget https://releases.linaro.org/components/kernel/uefi-linaro/latest/release/qemu64/QEMU_EFI.fd -O /opt/QEMU_EFI.fd
    ```
  
- Step 6: Run HelloWorld in QEMU
    ```
    qemu-system-aarch64 \
      -machine virt \
      -cpu cortex-a57 \
      -bios /opt/QEMU_EFI.fd \
      -kernel /opt/edk2/Build/MdeModule/DEBUG_GCC5/AARCH64/HelloWorld.efi \
      -nographic \
      -monitor none \
      -serial stdio
    ```
  
    Parameters:
    * -machine virt: Emulates a generic ARM virtual machine.
    * -cpu cortex-a57: Specifies the CPU model.
    * -bios: Loads the UEFI firmware.
    * -kernel: Directly boots the HelloWorld.efi application.
    * -nographic -serial stdio: Redirects output to the current terminal.
    
    Expected Output:
    ```
    UEFI Hello World!
    .......
    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).