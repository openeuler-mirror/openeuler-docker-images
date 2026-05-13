# Quick reference

- The official lancedb docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# lancedb | openEuler
Current lancedb docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

LanceDB is an open-source, serverless vector database designed for fast, scalable, and production-ready AI/ML applications. Built on top of the Lance columnar format, it supports multimodal data storage, vector similarity search, full-text search, and SQL queries.

Learn more on [LanceDB website](https://lancedb.com/).


# Supported tags and respective Dockerfile links
The tag of each lancedb docker image is consist of the version of lancedb and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[0.27.2-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/lancedb/0.27.2/24.03-lts-sp3/Dockerfile) | lancedb 0.27.2 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/lancedb` image from docker
  ```bash
  docker pull openeuler/lancedb:{Tag}
  ```

- Start a lancedb container with interactive Python shell
  ```bash
  docker run -it --name my-lancedb openeuler/lancedb:{Tag}
  ```

- Run a Python script with lancedb
  ```bash
  docker run --rm -v $(pwd):/workspace openeuler/lancedb:{Tag} python3 your_script.py
  ```

- Container startup options
  | Option | Description |
  |--|--|
  | `-v /path/to/data:/workspace` | Mount local directory for data persistence. |
  | `-v /path/to/scripts:/workspace` | Mount local directory containing Python scripts. |

- View container running logs
  ```bash
  docker logs -f my-lancedb
  ```

- To get an interactive shell
  ```bash
  docker exec -it my-lancedb /bin/bash
  ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
