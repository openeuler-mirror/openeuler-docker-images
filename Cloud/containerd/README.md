# Quick reference

- The official containerd docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# containerd | openEuler
Current containerd images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

containerd is an industry-standard container runtime with an emphasis on simplicity, robustness, and portability. It is available as a daemon for Linux and Windows, which can manage the complete container lifecycle of its host system: image transfer and storage, container execution and supervision, low-level storage and network attachments, etc.

Read more on [containerd Website](https://containerd.io/).

# Supported tags and respective dockerfile links
The tag of each `containerd` docker image is consist of the version of `containerd` and the version of basic image. The details are as follows

| Tag                                                                                                                                | Currently                                   | Architectures |
|------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------|---------------|
| [2.1.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/containerd/2.1.1/24.03-lts-sp1/Dockerfile) | containerd 2.1.1 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/containerd` image from docker

	```
	docker pull openeuler/containerd:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use containerd.
    ```
    docker run -it --rm openeuler/containerd:{Tag} bash
    ```
  
- Create a simple CNI configuration file
   
    Create a basic CNI config file(e.g., empty.conf) inside `/etc/cni/net.d/` to avoid network plugin errors when starting containerd:
    ```
    mkdir -p /etc/cni/net.d/
  
    # vi /etc/cni/net.d/empty.conf
    {
      "cniVersion": "0.4.0",
      "name": "empty-net",
      "type": "bridge",
      "bridge": "cni0",
      "isGateway": true,
      "ipMasq": true,
      "ipam": {
        "type": "host-local",
        "subnet": "10.88.0.0/16",
        "routes": [
          { "dst": "0.0.0.0/0" }
        ]
      }
    }
    ```
  
- Create the containerd configuration directory

    Make sure the containerd config directory exist:
    ```
    mkdir -p /etc/containerd
    ```

- Generate the default containerd configuration file
   
    Generate the default configuration and save it to `/etc/containerd/config.toml`:
    ```   
    ./containerd config default > /etc/containerd/config.toml
    ```
    
- Start containerd with the custom configuration

    Start the containerd daemon using the created config file in the background:
    ```
    ./containerd --config /etc/containerd/config.toml &
    ```
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).