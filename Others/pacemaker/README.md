# Quick reference

- The official Pacemaker docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Pacemaker | openEuler
Current Pacemaker docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Pacemaker is the resource manager for the ClusterLabs open-source high-availability cluster stack. It coordinates the configuration, start-up, monitoring, and recovery of interrelated services across all cluster nodes.

Learn more about Pacemaker on [Pacemaker Website](https://www.clusterlabs.org/pacemaker/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `pacemaker` docker image is consist of the version of `pacemaker` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[3.0.1-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/pacemaker/3.0.1/24.03-lts-sp2/Dockerfile) | pacemaker 3.0.1 on openEuler 24.03-LTS-SP2 | amd64, arm64 |
|[3.0.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/pacemaker/3.0.0/24.03-lts-sp1/Dockerfile)| Pacemaker 3.0.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/pacemaker` image from docker

	```bash
	docker pull openeuler/pacemaker:{Tag}
	```

- To get an interactive shell

	```
    docker run -it --rm openeuler/pacemaker:{Tag} bash
    ```
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).