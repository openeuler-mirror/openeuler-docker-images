# Quick reference

- The official ActiveMQ docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# ActiveMQ | openEuler
Current ActiveMQ docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache ActiveMQ is a high performance Apache 2.0 licensed Message Broker.

Learn more about activemq on [activemq Website](https://docs.activemqjs.com/about-activemq)⁠.

# Supported tags and respective Dockerfile links
The tag of each `activemq` docker image is consist of the version of `activemq` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[6.1.6-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/activemq/6.1.6/24.03-lts-sp1/Dockerfile)| ActiveMQ 6.1.6 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/activemq` image from docker

	```bash
	docker pull openeuler/activemq:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use activemq.
    ```
    docker run -it --rm openeuler/activemq:{Tag} bash
    ```

- Start ActiveMQ
    
    Run the following command to start ActiveMQ:
    ```
    ./bin/activemq start
    ```
    This starts the ActiveMQ broker in the background.

- Access the web console

    Use the following `curl` command to access the ActiveMQ interface:
    ```
    curl -u admin:admin -L http://localhost:8161/
    ```
    * `-u admin:admin`: provides the default username and password.
    * `-L`: allows `curl` to follow HTTP redirects.
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).