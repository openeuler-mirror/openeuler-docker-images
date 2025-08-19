# Quick reference

- The official HAProxy docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# HAProxy | openEuler
Current HAProxy docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

HAProxy is a free, very fast and reliable reverse-proxy offering high availability, load balancing, and proxying for TCP and HTTP-based applications.

Read more on [HAProxy Docs](http://docs.haproxy.org/).

# Supported tags and respective Dockerfile links
The tag of each `haproxy` docker image is consist of the version of `haproxy` and the version of basic image. The details are as follows

| Tag                                                                                                                              | Currently                                | Architectures |
|----------------------------------------------------------------------------------------------------------------------------------|------------------------------------------|---------------|
| [3.1.7-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/haproxy/3.1.7/24.03-lts-sp1/Dockerfile) | HAProxy 3.1.7 on openEuler 24.03-LTS-SP1 | amd64, arm64  |
| [3.2.0-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/haproxy/3.2.0/24.03-lts-sp2/Dockerfile) | HAProxy 3.2.0 on openEuler 24.03-LTS-SP2 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/haproxy` image from docker

	```bash
	docker pull openeuler/haproxy:{Tag}
	```

- Run with an interactive shell

    You can start the container with an interactive shell to use haproxy.
    ```
    docker run -it --rm openeuler/haproxy:{Tag} bash
    ```

- Create haproxy configuration file
    
    Create a file named `haproxy.cfg` in your working directory with the following contents:
    ```
    global
    daemon
    maxconn 256

    aults
        mode http
        timeout connect 5000ms
        timeout client 50000ms
        timeout server 50000ms

    frontend http_in
        bind *:8080
        default_backend servers

    backend servers
        server local_srv 127.0.0.1:8000 maxconn 32
    ```
    * `frontend` listens on port `8080`.
    * `backend` forwards traffic to `127.0.0.1:8080` inside the container.
  
- Start a simple backend HTTP server

    Run a basic HTTP server using Python3 on port 8080:
    ```
    nohup python3 -m http.server 8080 &
    ```
    This starts a minimal HTTP server that serves the current working directory on port `8080`.
  
- Start haproxy in the background

    ```
    haproxy -f haproxy.cfg
    ```
    HAProxy will listen on port `8080` and forward incoming requests to the local HTTP server on `127.0.0.1:8080`.
  
- Test haproxy HTTP service

    Access your service from your host machine:
    ```
    curl http://localhost:8080
    ```
    You should see the reponse from the local HTTP server through HAProxy.
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).