# Quick reference

- The official Spring Framework docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Spring Framework | openEuler
Current Spring Framework docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

The Spring Framework provides a comprehensive programming and configuration model for modern Java-based enterprise applications - on any kind of deployment platform.

A key element of Spring is infrastructural support at the application level: Spring focuses on the "plumbing" of enterprise applications so that teams can focus on application-level business logic, without unnecessary ties to specific deployment environments.

Learn more about Spring Framework on [Spring Framework Website](https://spring.io/projects/spring-framework)⁠.

# Supported tags and respective Dockerfile links
The tag of each `spring-framework` docker image is consist of the version of `spring-framework` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[6.2.6-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/spring-framework/6.2.6/24.03-lts-sp1/Dockerfile)| Spring Framework 6.2.6 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/spring-framework` image from docker

	```bash
	docker pull openeuler/spring-framework:{Tag}
	```
    
- Start a spring-framework instance
    ```bash
    docker run --rm openeuler/spring-framework:{Tag}
    ```
	If instance started successfully you will receive a "Hello, Spring Framework!" reply.

- To get an interactive shell

	```bash
	docker run -it --rm openeuler/spring-framework:{Tag} bash
	```
 
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).