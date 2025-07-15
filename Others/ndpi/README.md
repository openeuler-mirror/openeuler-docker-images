# Quick reference

- The official npdi docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# nDPI | openEuler
Current nDPI docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

nDPI® is an open source LGPLv3 library for deep-packet inspection.

Learn more on [nDPI website](https://www.ntop.org/).

# Supported tags and respective Dockerfile links
The tag of each npdi docker image is consist of the version of npdi and the version of basic image. The details are as follows

| Tags                                                                                                                          | Currently                             | Architectures |
|-------------------------------------------------------------------------------------------------------------------------------|---------------------------------------|---------------|
| [4.1.2-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/npdi/4.1.2/24.03-lts-sp1/Dockerfile) | nDPI 4.1.2 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}`  based on their requirements.

- Pull the `openeuler/npdi` image from docker

	```
	docker pull openeuler/npdi:{Tag}
	```

- Run with an interactive shell

    You can start the container with an interactive shell to use npdi.
    ```
    docker run -it --rm openeuler/npdi:{Tag} bash
    ```
  
- Download a sample PCAP

	```
	wget https://wiki.wireshark.org/uploads/__moin_import__/attachments/SampleCaptures/dns_port.pcap
	```
    **Node:**
    * This file contains DNS packets captured on a non-standard port.
    * It is commonly used to test how deep packet inspection works when protocols run on unusual ports.

- Run ndpiReader to analyze the PCAP
    
    ```
    /nDPI/example/ndpiReader -i dns_port.pcap
    ```
    **Note:**
    * `-i` specifies the input interface or PCAP file.
    * The tool will parse the packets, classify detected protocols, and output basic statistics.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).