# Quick reference

- The official Varnish Cache docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Varnish Cache | openEuler
Current Varnish Cache docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Varnish Cache is a web application accelerator also known as a caching HTTP reverse proxy. You install it in front of any server that speaks HTTP and configure it to cache the contents. Varnish Cache is really, really fast. It typically speeds up delivery with a factor of 300 - 1000x, depending on your architecture.

Read more on [Varnish Docs](https://varnish-cache.org/docs/index.html).

# Supported tags and respective Dockerfile links
The tag of each `varnish` docker image is consist of the version of `varnish` and the version of basic image. The details are as follows

| Tag                                                                                                                              | Currently                                      |   Architectures  |
|----------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------|------------------|
|[8.0.0-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/varnish/8.0.0/24.03-lts-sp2/Dockerfile) | varnish 8.0.0 on openEuler 24.03-LTS-SP2 | amd64, arm64 |
| [7.7.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/varnish/7.7.1/24.03-lts-sp1/Dockerfile) | Varnish Cache 7.7.1 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/varnish` image from docker

	```bash
	docker pull openeuler/varnish:{Tag}
	```

- Run with an interactive shell

    You can start the container with an interactive shell to use varnish.
    ```
    docker run -it --rm openeuler/varnish:{Tag} bash
    ```

- Create Varnish configuration file

    Create the directory to store Varnish configuration files:
    ```
    mkdir -p /etc/varnish
    ```
    
    Create the VCL file `/etc/varnish/default.vcl`, example content could be:
    ```
    vcl 4.0;

    backend default {
        .host = "127.0.0.1"; 
        .port = "8080";
    }
    ```
  
- Start a simple backend HTTP server

    Run a basic HTTP server using Python3 on port 8080:
    ```
    nohup python3 -m http.server 8080 &
    ```
    The python HTTP server acts as the backend that Varnish caches.
  
- Start Varnish in the background

    ```
    nohup varnishd -F -f /etc/varnish/default.vcl -a :6081 & 
    ```
    Varnish listens on port 6081 and forwards requests to the backend on port 8080.
  
- Test Varnish HTTP service

    Use `curl` to send a HEAD request and check if Varnish is responding:
    ```
    curl -I http://localhost:6081
    ```
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).