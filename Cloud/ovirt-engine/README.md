# Quick reference

- The official oVirt Engine docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# oVirt Engine | openEuler
Current oVirt Engine images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

oVirt Engine is the central management service of the oVirt virtualization platform.

# Supported tags and respective dockerfile links
The tag of each `ovirt-engine` docker image is consist of the version of `ovirt-engine` and the version of basic image. The details are as follows

| Tag                                                                                                                                  | Currently                                     | Architectures |
|--------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------|---------------|
| [4.5.6-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/ovirt-engine/4.5.6/24.03-lts-sp1/Dockerfile) | oVirt Engine 4.5.6 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/ovirt-engine` image from docker

	```
	docker pull openeuler/ovirt-engine:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use ovirt-engine.
    ```
    docker run -it --rm openeuler/ovirt-engine:{Tag} bash
    ```
  
- WildFly Standalone Server Startup Command
  
    Command Syntax
    ```
    /usr/share/ovirt-engine-wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0
    ```
    **Options Explained:**
    * `-b 0.0.0.0:` Bind to all available network interfaces(`0.0.0.0`).
    * `-bmanagement 0.0.0.0:` Listen for both application traffic and management traffic.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).