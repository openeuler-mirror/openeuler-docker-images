# Quick reference

- The official Netperf docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Netperf | openEuler
Current netperf docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Netperf is a benchmark that can be used to measure the performance of many different types of networking. It provides tests for both unidirectional throughput, and end-to-end latency.

# Supported tags and respective Dockerfile links
The tag of each `netperf` docker image is consist of the version of `netperf` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[2.7.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/netperf/2.7.0/24.03-lts-sp1/Dockerfile)| netperf 2.7.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/netperf` image from docker

	```bash
	docker pull openeuler/netperf:{Tag}
	```

- Run with an interactive shell

    You can start the container with an interactive shell to use netperf.
    ```
    docker run -it --rm openeuler/netperf:{Tag} bash
    ```

- Using netperf
    
    Start the `netserver` on  the server machine
    ```
    netserver -p <PORT>
    ```
    * Netserver listen on TCP port `PORT`, you can specify a custom port with `-p <PORT>`.
    * It binds to `0.0.0.0`(or IN(6)ADDR_ANY) by default, which means it listens in all available network interface.
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).