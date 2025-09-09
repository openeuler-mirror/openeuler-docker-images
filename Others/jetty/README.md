# Quick reference

- The official Jetty docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Jetty | openEuler
Current jetty docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Eclipse Jetty is a lightweight, highly scalable, Java-based web server and Servlet engine. Jetty's goal is to support web protocols (HTTP/1, HTTP/2, HTTP/3, WebSocket, etc.) in a high volume low latency way that provides maximum performance while retaining the ease of use and compatibility with years of Servlet development.

Learn more about Jetty on [Jetty documentation](https://jetty.org/docs/index.html)⁠.

# Supported tags and respective Dockerfile links
The tag of each `jetty` docker image is consist of the version of `jetty` and the version of basic image. The details are as follows

| Tag                                                                                                                                | Currently                                | Architectures |
|------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------|---------------|
| [12.1.1-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/jetty/12.1.1/24.03-lts-sp2/Dockerfile)   | Jetty 12.1.1 on openEuler 24.03-LTS-SP2  | amd64, arm64  |
| [12.1.0-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/jetty/12.1.0/24.03-lts-sp2/Dockerfile)   | Jetty 12.1.0 on openEuler 24.03-LTS-SP2  | amd64, arm64  |
| [12.0.21-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/jetty/12.0.21/24.03-lts-sp1/Dockerfile) | Jetty 12.0.21 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/jetty` image from docker

	```bash
	docker pull openeuler/jetty:{Tag}
	```

- Start a jetty instance

	```bash
	docker run -d --name my-jetty -p 8080:8080 openeuler/jetty:{Tag}
	```
	After the instance `my-jetty` is started, access the jetty service through `http://host-ip:8080`. 

- Deployment

    - Webapps can be deployed under /var/lib/jetty/webapps in the usual ways (WAR file, exploded WAR directory, or context XML file). 
    - There is a collection of [examples](https://github.com/jetty/jetty-examples) of how to use various features present in the Eclipse Jetty server and Eclipse Jetty client.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).