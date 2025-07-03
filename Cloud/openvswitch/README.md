# Quick reference

- The official Open vSwitch docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Open vSwitch | openEuler
Current Open vSwitch images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Open vSwitch is a multilayer software switch licensed under the open source Apache 2 license. Our goal is to implement a production quality switch platform that supports standard management interfaces and opens the forwarding functions to programmatic extension and control.

# Supported tags and respective dockerfile links
The tag of each `openvswitch` docker image is consist of the version of `openvswitch` and the version of basic image. The details are as follows

| Tag                                                                                                                                           | Currently                                     | Architectures |
|-----------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------|---------------|
| [3.5.0-oe2403sp1](https://gitee.com/openeuler/openeuler-openvswitch-images/blob/master/Cloud/openvswitch/3.5.0/24.03-lts-sp1/openvswitchfile) | Open vSwitch 3.5.0 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/openvswitch` image from docker

	```
	docker pull openeuler/openvswitch:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use open vSwitch.
    ```
    docker run -it --rm --privileged openeuler/openvswitch bash
    ```
    The container should run in `--privileged` mode or wit `CAP_NET_ADMIN` and `CAP_SYS_MODULE` capabilities.
  
- Create the OVS database directories
  
    ```
    mkdir -p /usr/local/etc/openvswitch
    mkdir -p /usr/local/var/run/openvswitch
    ```

- Initialize the OVS configuration database

    This command creates `conf.db` using the provided schema.
    ```   
    ovsdb-tool create /usr/local/etc/openvswitch/conf.db /usr/local/share/openvswitch/vswitch.ovsschema
    ```
  
- Start the `ovsdb-server` process

    ```   
    ovsdb-server \
      --remote=punix:/usr/local/var/run/openvswitch/db.sock \
      --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
      --pidfile --detach
    ```
    * `--remote=punix:...:` sets up a local UNIX socket for `ovs-vswitchd` to communicate.
    * `--remote=db:...:` allows `ovs-vsctl` to modify the database.
    * `--pidfile:` writes the process ID to a file.
    * `--detach:` runs it in the background.

- Initialize the OVS database

    This sets up the default Open vSwitch database tables if they don't exist.
    ```
    ovs-vsctl --no-wait init
    ```
  
- Start the `ovs-switchd` process

    This starts the main switching daemon, which talks to the kernel mode.
    ```
    ovs-vswitchd unix:/usr/local/var/run/openvswitch/db.sock --pidfile --detach
    ```
  
- Create a new birge

    Creates a new virtual switch brige named `br0`.
    ``` 
    ovs-vsctl add-br br0
    ```
  
- Verify the brige

    ```
    ovs-vsctl show
    ```
  
    Sample output:
    ```
    8d72419a-06d6-491b-aac0-85554e26dca0
    Bridge br0
        Port br0
            Interface br0
                type: internal
    ```
    This confirms the `br0` bridge was created successfully with an internal interface.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).