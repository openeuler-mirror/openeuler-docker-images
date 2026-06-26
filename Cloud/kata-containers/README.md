# Quick reference

- The official Kata Containers docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# Kata Containers | openEuler
Current Kata Containers images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Kata Containers is an open-source secure container runtime that runs each container inside a lightweight virtual machine, combining the security isolation of VMs with the speed and manageability of containers. It is a CNCF incubating project. This image includes three core Go components from the `src/runtime` module: `kata-runtime` (OCI-compatible runtime), `containerd-shim-kata-v2` (containerd integration shim), and `kata-monitor` (monitoring and metrics component).

Read more on [Kata Containers Website](https://katacontainers.io/).

# Supported tags and respective dockerfile links
The tag of each `kata-containers` docker image is consist of the version of `kata-containers` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
| [3.31.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Cloud/kata-containers/3.31.0/24.03-lts-sp3/Dockerfile) | Kata Containers 3.31.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/kata-containers` image from docker

	```
	docker pull openeuler/kata-containers:{Tag}
	```

- Check the kata-runtime version

    ```
    docker run --rm openeuler/kata-containers:{Tag} kata-runtime --version
    ```

- Run the Kata Containers environment check

    ```
    docker run --rm --privileged openeuler/kata-containers:{Tag} kata-runtime kata-check
    ```

- Start kata-monitor

    ```
    docker run --rm openeuler/kata-containers:{Tag} kata-monitor --help
    ```

- Run with an interactive shell

    ```
    docker run -it --rm openeuler/kata-containers:{Tag} bash
    ```
    The `openeuler/kata-containers` image is used to verify the integration between the upstream Kata Containers version and openEuler.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
