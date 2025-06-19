# Quick reference

- The official Data Plane Development Kit (DPDK) docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Data Plane Development Kit (DPDK) | openEuler
Current DPDK docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Data Plane Development Kit (DPDK) is a Linux Foundation project that consists of libraries to accelerate packet 
processing workloads running on a wide variety of CPU architectures.

Learn more about DPDK on [DPDK Website](hhttps://core.dpdk.org/doc/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `dpdk` docker image is consist of the version of `dpdk` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[25.03-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/dpdk/25.03/24.03-lts-sp1/Dockerfile)| DPDK 25.03 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/dpdk` image from docker

	```bash
	docker pull openeuler/dpdk:{Tag}
	```

- Temporary set up hugePages(resets after reboot)

    ```	
    echo 64 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
    mkdir -p /dev/hugepages
    mount -t hugetlbfs nodev /dev/hugepages
	```
    This will enable 64 hugepages of 2MB each and mount them to `/dev/hugepages`.
 
- Running a DPDK Container with HugePages
    ```
    docker run -it --rm \
      --cap-add=IPC_LOCK \
      --privileged \
      -v /dev/hugepages:/dev/hugepages \
      -v /sys/bus/pci:/sys/bus/pci \
      -v /sys/devices:/sys/devices \
      -v /sys/kernel/mm/hugepages:/sys/kernel/mm/hugepages \
      -v /lib/modules:/lib/modules \
      --network host \
      openeuler/dpdk:{Tag} bash
    ```
    * `--privileged`: Grants access to device bindings (e.g., VFIO) and hugepages
    * `--network host`: Enable DPDK to access the actual physical NIC on the host
    
- Run DPDK sample application
    Once inside the container:
    ```
    cd /dpdk/examples/helloworld
    make
    ./build/helloworld -l 0 -n 2
    ```
    This compiles and runs the DPDK `helloworld` example, binding it to logical core 0 and using 2 memory channels.
 
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).