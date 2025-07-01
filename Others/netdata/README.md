# Quick reference

- The official Netdata docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Netdata | openEuler
Current Netdata docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Netdata is an open-source, real-time infrastructure monitoring platform. Monitor, detect, and act across your entire infrastructure.

Learn more on [netdata website](https://netdata.org/docs/latest/introduction/index.html).

# Supported tags and respective Dockerfile links
The tag of each netdata docker image is consist of the version of netdata and the version of basic image. The details are as follows

| Tags                                                                                                                             | Currently                                |  Architectures|
|----------------------------------------------------------------------------------------------------------------------------------|------------------------------------------|--|
| [2.5.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/netdata/2.5.0/24.03-lts-sp1/Dockerfile) | Netdata 2.5.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}`  based on their requirements.

- Pull the `openeuler/netdata` image from docker

	```
	docker pull openeuler/netdata:{Tag}
	```
 
- Run with an interactive shell

    You can start the container with an interactive shell to use netdata.
    ```
    docker run -it --rm openeuler/netdata:{Tag} bash
    ```
    
- Run the Netdata process

    Execute the following command to start Netdata manually.
	```
	netdata/bin/netdata
	```
 	This starts the Netdata monitoring agent in the foreground, you can run it in the background using `&` if needed.

- Access the web dashboard
   
    Once Netdata is running, you can access web dashboard. 
	```
	http://localhost:19999
	```
    This will bring up the Netdata real-time monitoring dashboard, where you can view system metrics such as CPU, memory, disk I/O, network traffic, and more.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).