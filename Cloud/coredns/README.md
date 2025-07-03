# Quick reference

- The official CoreDNS docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# CoreDNS | openEuler
Current coredns images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

CoreDNS is a DNS server. It is written in Go. It can be used in a multitude of environments because of its flexibility. CoreDNS is licensed under the Apache License Version 2, and completely open source.

Read more on [CoreDNS Website](https://coredns.io/).

# Supported tags and respective dockerfile links
The tag of each `coredns` docker image is consist of the version of `coredns` and the version of basic image. The details are as follows

| Tag                                                                                                                                 | Currently                                 | Architectures |
|-------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|---------------|
| [1.12.1-oe2403sp1](https://gitee.com/openeuler/openeuler-coredns-images/blob/master/Cloud/coredns/1.12.1/24.03-lts-sp1/corednsfile) | CoreDNS 1.12.1 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/coredns` image from docker

	```
	docker pull openeuler/coredns:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use coredns.
    ```
    docker run -it --rm openeuler/coredns:{Tag} bash
    ```
  
- Create a `Corefile`
  
    In your current working directory, create a simple `Corefile`:
    ```
    # Corefile
    .:53 {
        forward . 8.8.8.8
        log
    }
    ```
    What this means:
    * `.:53`: Listen for all DNS queries on port 53.
    * `forward . 8.8.8.8`: Forward all DNS queries to Google Public DNS. You can replace `8.8.8.8` with your loca DNS server if needed.
    * `log`: Log each DNS request for debugging.

- Start CoreDNS (Run as a local binary)
   
    If you have the `coredns` binary, start it with:
    ```   
    ./coredns -conf Corefile
    ```
    After starting, CoreDNS will listen on `0.0.0.0:53` and forward incoming DNS queries according to your configuration.
    
- Test DNS Resolution

    Use `dig` on your container to test if CoreDNS is working:
    ```
    # You should install bind-utils first in order to use the dig command.
    dnf install -y bind-utils
    dig @127.0.0.1 www.example.com
    ```
    You should see a DNS response in your terminal, and CoreDNS should log the request in its output.
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).