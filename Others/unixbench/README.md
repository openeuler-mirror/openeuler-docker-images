# Quick reference

- The official UnixBench docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# UnixBench  | openEuler
Current UnixBench  docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

UnixBench is the original BYTE UNIX benchmark suite, updated and revised by many people over the years.

# Supported tags and respective Dockerfile links
The tag of each `unixbench` docker image is consist of the version of `unixbench` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[6.0.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/unixbench/6.0.0/24.03-lts-sp1/Dockerfile)| UnixBench  6.0.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/unixbench` image from docker

	```bash
	docker pull openeuler/unixbench:{Tag}
	```
 
- Run with an interactive shell

    You can also start the container with an interactive shell to use unixbench.
    ```
    docker run -it --rm openeuler/unixbench:{Tag} bash
    ```

- System Benchmark

    Run is the main script used to run UnixBench, a widely used system benchmark suite for Unix-like operating systems.
    ```
    ./Run dhry2reg
    ```
    Executing the `Dhrystone 2` benchmark instead of running the full UnixBench suite.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).