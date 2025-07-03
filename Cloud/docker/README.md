# Quick reference

- The official Docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Docker | openEuler
Current Docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Docker is an open platform for developing, shipping, and running applications. Docker enables you to separate your applications from your infrastructure so you can deliver software quickly. With Docker, you can manage your infrastructure in the same ways you manage your applications. By taking advantage of Docker's methodologies for shipping, testing, and deploying code, you can significantly reduce the delay between writing code and running it in production.

Learn more about Docker on [Docker Website](https://www.docker.com/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `docker` docker image is consist of the version of `docker` and the version of basic image. The details are as follows

| Tag                                                                                                                              | Currently                                | Architectures |
|----------------------------------------------------------------------------------------------------------------------------------|------------------------------------------|---------------|
| [28.2.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/docker/28.2.1/24.03-lts-sp1/Dockerfile) | Docker 28.2.1 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/docker` image from docker

	```bash
	docker pull openeuler/docker:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use docker.
    ```
    docker run -it -v /var/run/docker.sock:/var/run/docker.sock --rm openeuler/docker:{Tag} bash
    ```
  
- Mount the Docker socket when starting your container
  
    When you run your container, make sure to mount the host machine's Docker socker:
    ```
    docker run -it --rm \
      -v /var/run/docker.sock:/var/run/docker.sock \
      openeuler/docker:{Tag} bash
    ```
    **Key Points:**
    * `-v /var/run/docker.sock:/var/run/docker.sock:` This allows the container's Docker CLI to communicate with the host's Docker daemon.
    * Docker is installed on the host machine.

- Pull the `openeuler/openeuler:latest` image

    Inside the container, use the `./docker` CLI to pull the image from Docker Hub:
    ```   
    ./docker pull openeuler/openeuler:latest
    ```
  
- Run the openEuler container

    Finally, run the openEuler image with an interactive terminal:
    ```   
    ./docker run -it --rm openeuler/openeuler:latest
    ```
    * `-it:` Start an interactive terminal
    * `--rm:` Automatically remove the container when it exits.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).