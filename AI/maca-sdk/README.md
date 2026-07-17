# Quick reference

- The official MACA (MetaX Accelerated Computing Architecture) SDK docker image.

- Maintained by: [openEuler Intelligence SIG](https://www.openeuler.openatom.cn/en/sig/sig-intelligence).

- Where to get help: [openEuler Intelligence SIG](https://www.openeuler.openatom.cn/en/sig/sig-intelligence), [openEuler](https://gitee.com/openeuler/community).

## MACA SDK | openEuler

Current MACA SDK docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

MACA (MetaX Accelerated Computing Architecture, also marketed as MXMACA) is the heterogeneous compute software stack developed by [MetaX (沐曦)](https://www.metax-tech.com/) for the 曦云 (XiYun / C500) series general-purpose computing GPUs. It provides the runtime, compilers, operator libraries and toolchain that let you quickly build AI training, inference and HPC applications on top of MetaX GPUs.

Learn more in the [MetaX Developer Community](https://developer.metax-tech.com/).

## Supported tags and respective Dockerfile links

The tag of each `maca-sdk` docker image is composed of the SDK version and the openEuler base image version. The details are as follows

| Tag                                                                                                                            | Currently                                            | Architectures |
|--------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------|---------------|
| [3.7-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/maca-sdk/3.7/24.03-lts-sp3/Dockerfile)      | MACA SDK 3.7.0.38 on openEuler 24.03-LTS-SP3         | amd64, arm64  |

## Usage

In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

> **Prerequisite:** Before launching the container, the host must have the MetaX GPU driver (`mxdriver`) and the `mx-smi` management tool installed, and the GPU must be visible on the host (run `mx-smi` to verify).

- Pull the `openeuler/maca-sdk` image from docker

    ```bash
    docker pull openeuler/maca-sdk:{Tag}
    ```

- Start a maca-sdk instance

    ```bash
    docker run -it --rm \
      --device /dev/dri \
      --device /dev/mxcd \
      --device /dev/infiniband \
      --privileged=true \
      --group-add video \
      --network=host \
      -v /sys/kernel/debug:/sys/kernel/debug \
      -v /opt/mxdriver:/opt/mxdriver \
      -v /usr/bin/mx-smi:/usr/bin/mx-smi \
      --name mxsdk \
      -v /root:/root \
      openeuler/maca-sdk:{Tag}
    ```

- Container startup options

    | Option | Description |
    | --- | --- |
    | `--name mxsdk` | Names the container `mxsdk`. |
    | `--device /dev/dri` | Maps the Direct Rendering Infrastructure (DRM) render nodes so the container can access the GPU graphics/compute context. |
    | `--device /dev/mxcd` | Maps the MetaX compute device (`mxcd`), the entry point used by MACA to submit compute tasks to the GPU. |
    | `--device /dev/infiniband` | Maps the InfiniBand device, enabling RDMA / high-bandwidth interconnect for multi-card and distributed training. Optional if InfiniBand is not used. |
    | `--privileged=true` | Grants extended privileges so the runtime can access driver interfaces under `/dev` and `/sys/kernel/debug`. Tighten this if your environment allows device-level mappings only. |
    | `--group-add video` | Adds the container's user to the host `video` group so it has the permissions required to access `/dev/dri/*`. |
    | `--network=host` | Shares the host network namespace. Required by some distributed training and RPC backends; remove if you prefer bridge networking. |
    | `-v /sys/kernel/debug:/sys/kernel/debug` | Mounts the host debugfs so driver/runtime diagnostics (e.g. profiling tools) can be collected. |
    | `-v /opt/mxdriver:/opt/mxdriver` | Mounts the host MetaX driver directory into the container. The MACA runtime must match the driver version installed on the host. |
    | `-v /usr/bin/mx-smi:/usr/bin/mx-smi` | Mounts the host `mx-smi` (MetaX System Management Interface) tool so you can query GPU status from inside the container. |
    | `-v /root:/root` | Mounts the host `/root` directory, convenient for sharing code, datasets and credentials. Adjust the path to your own working directory. |
    | `-it` | Starts the container in interactive mode with a terminal. |
    | `--rm` | Automatically removes the container when it exits. |
    | `openeuler/maca-sdk:{Tag}` | Specifies the Docker image to run, replace `{Tag}` with the specific version or tag of the `openeuler/maca-sdk` image you want to use. |

- Verify that the GPU is visible inside the container

    ```bash
    mx-smi
    ```

- View container running logs

    ```bash
    docker logs -f mxsdk
    ```

- To get an interactive shell

    ```bash
    docker exec -it mxsdk /bin/bash
    ```

## Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
