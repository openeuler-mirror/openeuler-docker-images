# Quick reference

- The official Rinetd docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Rinetd | openEuler
Current Rinetd docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Rinetd is a simple TCP port redirection server — it allows you to forward connections from one IP/port to another.

Learn more about rinetd on [rinetd Website](https://docs.rinetdjs.com/about-rinetd)⁠.

# Supported tags and respective Dockerfile links
The tag of each `rinetd` docker image is consist of the version of `rinetd` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[0.73-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/rinetd/0.73/24.03-lts-sp1/Dockerfile)| Rinetd 0.73 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/rinetd` image from docker

	```bash
	docker pull openeuler/rinetd:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use rinetd.
    ```
    docker run -it --rm openeuler/rinetd:{Tag} bash
    ```

- Configuration File
    
    The default configuration file is typically located at `/etc/rinetd.conf`.
    Format:
    ```
    bindaddress  bindport  connectaddress  connectport
    ```
    
    Example:
    ```
    0.0.0.0 8080 127.0.0.1 80
    ```
    This will forward all traffic received on `port 8080` (on any local interface) to `localhost:80`.

- Start rinetd

    ```
    rinetd -c /etc/rinetd.conf
    ```

- Check listening port

    ```
    dnf install -y iproute
    ss -ltnp | grep rinetd
    ```
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).