# Quick reference

- The official Keepalived docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Keepalived | openEuler
Current Keepalived docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Keepalived is a routing software written in C. The main goal of this project is to provide simple and robust facilities for loadbalancing and high-availability to Linux system and Linux based infrastructures. 

Read more on [Keepalived Documentation](https://www.keepalived.org/manpage.html).

# Supported tags and respective Dockerfile links
The tag of each `keepalived` docker image is consist of the version of `keepalived` and the version of basic image. The details are as follows

| Tag                                                                                                                              | Currently                                     |   Architectures  |
|----------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------|------------------|
| [2.3.3-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/keepalived/2.3.3/24.03-lts-sp1/Dockerfile) | Keepalived 2.3.3 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/keepalived` image from docker

	```bash
	docker pull openeuler/keepalived:{Tag}
	```

- Run with an interactive shell

    Run your container with the `--privileged` flag to allow Keepalived to manage network interfaces and bind virtual IP address. 
    ```
    docker run -it --privileged --rm openeuler/keepalived:{Tag} bash
    ```
    This starts the container in an interactive shell with full privileges.

- Check the actual network interface and subnet

    Inside the keepalived container, install `iproute` if not already present, and then check the network interface details to identify the IP address and subnet mask of the `eth0` interface:    
    ```
    dnf install -y iproute
    ip addr show eth0
    ```
    Note the IP address and subnet(e.g., 172.17.0.8/16) -- you will need this information for configuring Keepalived.
  
- Prepare your keepalived configuration file

    Create or edit the `keepalived.conf` file. Here is an example configuration based on the subnet found above(`172.17.0.0/16`):
    ```
    global_defs {
       router_id my_keepalived
    }

    vrrp_instance VI_1 {
       state MASTER
       interface eth0
       virtual_router_id 51
       priority 100
       advert_int 1
       authentication {
           auth_type PASS
           auth_pass 123456
       }
       virtual_ipaddress {
           172.17.0.100/16
       }
    }
    ```
    Make sure to adjust `interface` and `virtual_ipaddress` according to your enviroment.
  
- Start keepalived

    Start Keepalived in the foreground with detailed logging to monitor it's opetation:
    ```
    keepalived -n -l -d -f keepalived.conf
    ```
    Flags explained:
    * `-n`: run in the foreground(no daemonize)
    * `-l`: log output to the terminal
    * `-d`: enable debug logging
    * `-f`: specify the configuration file
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).