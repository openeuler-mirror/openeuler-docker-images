# Quick reference

- The official Suricata docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Suricata | openEuler
Current Suricata docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Suricata is a high performance Network IDS, IPS and Network Security Monitoring engine.
It is open source and owned by a community-run non-profit foundation,
the Open Information Security Foundation ([OISF](https://oisf.net/)). Suricata is developed by the OISF.

# Supported tags and respective Dockerfile links
The tag of each suricata docker image is consist of the version of suricata and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[7.0.8-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/suricata/7.0.8/24.03-lts/Dockerfile)| suricata 7.0.8 on openEuler 24.03-LTS | amd64, arm64 |


# Usage
In this usage, users can select the corresponding `{Tag}`  based on their requirements.

- Online Documentation
  You can find the latest suricata documentation, including a programming guide, on the [project web page](https://docs.suricata.io/en/latest/).
  This README file only contains basic setup instructions.
- 
- Pull the `openeuler/suricata` image from docker
    ```bash
    docker pull openeuler/suricata:{Tag}
    ```

- Usage
  You will most likely want to run Suricata on a network interface on your host machine rather than the network interfaces normally provided inside a container:
    ```bash
    docker run -it --rm \
    -v /var/log/suricata:/var/log/suricata \
    -v /var/lib/suricata:/var/lib/suricata \
    -v /var/run/suricata:/var/run/suricata \
    -v /etc/suricata:/etc/suricata \
    --net=host \
    --cap-add=net_admin \
    --cap-add=net_raw \
    --cap-add=sys_nice \
    openeuler/suricata:<Tag> \
    -i eth0
    ```
  Additionally, this container will attempt to run Suricata as a non-root user provided the containers has the
  capabilities to do so. In order to monitor a network interface, and drop root privileges the container must
  have the `sys_nice`, `net_admin`, and `net_raw` capabilities. If the container detects that it does not have
  these capabilities, Suricata will be run as root.


- Container startup options

  | Option | Description |
  |----------|----------|
  | `-i eth0` | Specify that Suricata should monitor the network interface `eth0`. |
  | `-v /var/log/suricata:/var/log/suricata` | Mount the log directory. |
  | `-v /var/lib/suricata:/var/lib/suricata` | Mount the lib directory. |
  | `-v /etc/suricata:/etc/suricata` | Mount the configuration file directory. |
  | `-v /etc/suricata:/etc/suricata` | Mount the configuration file directory. |
  | `--cap-add=net_admin` | Allow the container to perform network administration tasks. |
  | `--cap-add=sys_nice` | Allow the container to adjust the priority (nice value) of processes running inside it. |
  | `--cap-add=net_raw` | Grant the container the ability to send and receive raw network packets. |
  | `--net=host` | Allows the container to use the host's network directly. |


- To get an interactive shell
  ```bash
  docker run -it --rm --entrypoint bash openeuler/suricata:{Tag} bash
  ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).

