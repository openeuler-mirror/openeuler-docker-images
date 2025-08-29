# Quick reference

- The official wireshark docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# wireshark | openEuler
Current wireshark docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Wireshark is a network traffic analyzer, or "sniffer", for Linux, macOS,
*BSD and other Unix and Unix-like operating systems and for Windows.
It uses Qt, a graphical user interface library, and libpcap and npcap as
packet capture and filtering libraries.

Learn more about wireshark on [wireshark Website](https://www.wireshark.org/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `wireshark` docker image is consist of the version of `wireshark` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[4.4.9-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/wireshark/4.4.9/24.03-lts-sp1/Dockerfile) | wireshark 4.4.9 on openEuler 24.03-LTS-SP1 | amd64, arm64 |
|[4.4.6-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/wireshark/4.4.6/24.03-lts-sp1/Dockerfile)| wireshark 4.4.6 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/wireshark` image from docker

	```bash
	docker pull openeuler/wireshark:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use wireshark. Additionally, you can run `tshark --help` learn how to use its commands.
    ```
    docker run -it --rm openeuler/wireshark:{Tag} bash
    ```

- List available interfaces
    
    This command lists all network interfaces on the system that `tshark` can capture packets from.
    ```
    tshark -D
    ```

- Capture packets on a specific interface
    
    To write the capture packets to a `.pcap` file.
    ```
    tshark -i xxx -w capture_output.pcap
    ```
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).