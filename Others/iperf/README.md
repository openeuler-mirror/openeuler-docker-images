# Quick reference

- The official iperf docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# iperf | openEuler
Current iperf docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

iperf is a tool for active measurements of the maximum achievable bandwidth on IP networks. It supports tuning of various parameters related to timing, protocols, and buffers. For each test it reports the measured throughput / bitrate, loss, and other parameters.

Learn more about iperf on [iperf Website](https://fasterdata.es.net/performance-testing/network-troubleshooting-tools/iperf/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `iperf` docker image is consist of the version of `iperf` and the version of basic image. The details are as follows

|    Tag   | Currently                                 |   Architectures  |
|----------|-------------------------------------------|------------------|
|[3.19-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/iperf/3.19/24.03-lts-sp1/Dockerfile)| iperf 3.19 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/iperf` image from docker

	```bash
	docker pull openeuler/iperf:{Tag}
	```

- Basic Usage

    Start the server (default port: 5201)
    ```
    iperf3 -s
    ```
  
   Output Example:
   ```
   Server is listening on 5201
   ```
  
   Run on custom port
   ```
   iperf3 -s -p 9000
   ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).