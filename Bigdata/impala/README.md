# Quick reference

- The official impala docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Impala | openEuler
Current impala docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Impala is a modern, massively-distributed, massively-parallel, C++ query engine that lets you analyze, transform and combine data from a variety of data sources. 
This image is the base environment with impala compiled.

Learn more about Impala on [Impala Website](https://impala.apache.org/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `impala` docker image is consist of the version of `impala` and the version of basic image. The details are as follows

| Tag                                                                                                                              | Currently                                      | Architectures |
|----------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------|---------------|
| [4.4.1-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/impala/4.4.1/24.03-lts/Dockerfile)     | Apache impala 4.4.1 on openEuler 24.03-LTS     | amd64, arm64  |
| [4.5.0-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/impala/4.5.0/24.03-lts-sp2/Dockerfile) | Apache impala 4.5.0 on openEuler 24.03-LTS-SP2 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/impala` image from docker

	```bash
	docker pull openeuler/impala:{Tag}
	```

- Start a impala instance

	```bash
	docker run -d --name my-impala openeuler/impala:{Tag}
	```

- View container running logs

	```bash
	docker logs -f my-impala
	```

- To get an interactive shell

	```bash
	docker run -it --name my-impala openeuler/impala:{Tag} bash
	```
        
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).