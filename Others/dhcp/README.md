# Quick reference

- The official DHCP docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# DHCP | openEuler
Current dhcp docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

DHCP, or Dynamic Host Configuration Protocol, is a network management protocol that automatically assigns IP addresses and other network configuration parameters to devices on a network.

Learn more about DHCP on [DHCP Website](https://www.isc.org/blogs/isc-dhcp-eol/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `dhcp` docker image is consist of the version of `dhcp` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[4.4.3-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/dhcp/4.4.3/24.03-lts-sp1/Dockerfile)| DHCP 4.4.3 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/dhcp` image from docker

	```bash
	docker pull openeuler/dhcp:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use dhcp.
    ```
    docker run -it --rm openeuler/dhcp:{Tag} bash
    ```
  
- Create the `dhcpd.conf` file
  
    Add a subnet declaration matching the `eth0` interface`s IP. For example:
    ```
    # Configure subnet based on eth0's IP (172.17.0.7)
    subnet 172.17.0.0 netmask 255.255.0.0 {
      range 172.17.1.100 172.17.1.200;       # Allocatable IP range
      option routers 172.17.0.1;             # Default gateway (modify as needed)
      option domain-name-servers 8.8.8.8;    # DNS server
      default-lease-time 600;                # Default lease time (seconds)
      max-lease-time 7200;
    }
    ```
    **Key Points:**
    * The subnet range and netmask must cover eth0`s IP(172.17.0.7).
    * If your actual network is `172.17.0.0/24`, change the netmask to `255.255.255.0`.

- Specify listening interface(Optional)

    Force binding to `eth0` during startup:
    ```   
    /usr/local/dhcp/sbin/dhcpd -cf /tmp/dhcp/dhcpd.conf eth0 -f
    ```
    **Notes:**
    * The `-f` flag keeps the process in foreground or debugging.
    * Omit `-f` to run as a background daemon.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).