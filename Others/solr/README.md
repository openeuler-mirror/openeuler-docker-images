# Quick reference

- The official solr docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# solr | openEuler
Current solr docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Solr is the blazing-fast, open source, multi-modal search platform built on Apache Lucene. It powers full-text, vector, and geospatial search at many of the world's largest organizations.

# Supported tags and respective Dockerfile links
The tag of each `solr` docker image is consist of the version of `solr` and the version of basic image. The details are as follows

| Tag                                                                                                                             | Currently                              | Architectures |
|---------------------------------------------------------------------------------------------------------------------------------|----------------------------------------|---------------|
| [9.8.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/solr/9.8.1/24.03-lts-sp1/Dockerfile) | Apache Solr 9.8.1 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
- Pull the `openeuler/solr` image from docker

	```bash
	docker pull openeuler/solr:latest
	```

- Start a solr instance

    ```
    docker run -it openeuler/solr:latest
    ```
    The `openeuler/solr` image is used to verify the integration between the upstream msolresa version and openEuler. 

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).