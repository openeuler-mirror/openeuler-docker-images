# Quick reference

- The official dnsmasq docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# dnsmasq | openEuler
Current dnsmasq docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

dnsmasq is the world's largest software registry. Open source developers from every continent use dnsmasq to share and borrow packages, and many organizations use dnsmasq to manage private development as well.

Learn more about dnsmasq on [dnsmasq Website](https://docs.dnsmasqjs.com/about-dnsmasq)⁠.

# Supported tags and respective Dockerfile links
The tag of each `dnsmasq` docker image is consist of the version of `dnsmasq` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[2.91-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/dnsmasq/2.91/24.03-lts-sp1/Dockerfile)| dnsmasq 2.91 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/dnsmasq` image from docker

	```bash
	docker pull openeuler/dnsmasq:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use dnsmasq.
    ```
    docker run -it --rm openeuler/dnsmasq:{Tag} bash
    ```

- Create the `/etc/dnsmasq.conf` file
  
    Create a local configuration file `dnsmasq.conf` with the following content:
    ```
    # dnsmasq.conf
    no-resolv
    address=/test.local/192.168.1.100
    log-queries
    log-facility=/var/log/dnsmasq.log
    ```
  
- Start the `dnsmasq` service in background

    ```
    nohup dnsmasq --no-daemon &
    ```
    To make sure it's running:
    ```
    ps aux | grep dnsmasq
    ```

- Test using the `dig` command:

    ```
    dnf install -y bind-utils
    dig @127.0.0.1 test.local
    ```
  
- Expected output (similar to):

    ```
    ;; ANSWER SECTION:
    test.local.     0   IN  A   192.168.1.100
    ```
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).