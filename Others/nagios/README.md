# Quick reference

- The official Nagios docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Nagios | openEuler
Current Nagios docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Nagios is a host/service/network monitoring program written in C and released under the GNU General Public License, version 2. CGI programs are included to allow you to view the current status, history, etc via a web interface if you so desire.

Learn more on [Nagios website](https://assets.nagios.com/downloads/nagioscore/docs/nagioscore/4/en/toc.html).

# Supported tags and respective Dockerfile links
The tag of each nagios docker image is consist of the version of nagios and the version of basic image. The details are as follows

| Tags                                                                                                                             | Currently                                |  Architectures|
|----------------------------------------------------------------------------------------------------------------------------------|------------------------------------------|--|
| [4.5.9-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/nagios/4.5.9/24.03-lts-sp1/Dockerfile) | Nagios 4.5.9 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}`  based on their requirements.

- Pull the `openeuler/nagios` image from docker

	```
	docker pull openeuler/nagios:{Tag}
	```

- Run with an interactive shell

    You can start the container with an interactive shell to use nagios.
    ```
    docker run -it --rm openeuler/nagios:{Tag} bash
    ```
  
- Run the nagios process

    This command starts the `Nagios Core` monitoring system using the specified configuration file (`nagios.cfg`). It initializes the Nagios daemon, loads the
    defined hosts, services, and checks, and begins monitoring based on the provided configurations.
	```
	/usr/local/nagios/bin/nagios /opt/nagioscore-nagios/t/etc/nagios.cfg
	```
    **Parameters:**
    * `/usr/local/nagios/bin/nagios:` The Nagios binary executable.
    * `/opt/nagioscore-nagios/t/etc/nagios.cfg:` Path to the main Nagios configuration file. Typically located in `/opt/nagioscore-nagios/t/etc/nagios.cfg`.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).