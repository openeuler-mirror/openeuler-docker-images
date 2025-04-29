# Quick reference

- The official druid docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Druid | openEuler
Current druid docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Druid is a high performance real-time analytics database. Druid's main value add is to reduce time to insight and action.

Learn more about Druid on [Druid Website](https://druid.apache.org/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `druid` docker image is consist of the version of `druid` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[32.0.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/druid/32.0.1/24.03-lts-sp1/Dockerfile)| Apache druid 32.0.1 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage

In this usage, users can select the corresponding `{Tag}` based on their requirements.

Run with the single server deployment, which automatically configures various memory-related parameters based on the 
available processors and memory, using the default JVM arguments and service-specific runtime properties.

- Pull the `openeuler/druid` image from docker

  ```bash
  docker pull openeuler/druid:{Tag}
  ```

- Start a druid instance

  ```bash
  docker run -d -p 8888:8888 --name my-druid openeuler/druid:{Tag}
  ```
  After the instance `my-druid` is started, access the web console through `http://{ip}:8888`.

- View container running logs

  ```bash
  docker logs -f my-druid
  ```
  
- To get an interactive shell

	```bash
	docker exec -it my-druid /bin/bash
	```
        
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
