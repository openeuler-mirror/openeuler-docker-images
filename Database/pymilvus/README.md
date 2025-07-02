# Quick reference

- The official Milvus docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Milvus | openEuler
Current Milvus docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Milvus is a high-performance, cloud-native vector database built for scalable vector ANN search.

Read more on [Milvus Website](https://milvus.io/docs).

# Supported tags and respective Dockerfile links
The tag of each `pymilvus` docker image is consist of the version of `pymilvus` and the version of basic image. The details are as follows

| Tag                                                                                                                                 |  Currently  |   Architectures  |
|-------------------------------------------------------------------------------------------------------------------------------------|-------------|------------------|
| [2.5.6-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/pymilvus/2.5.6/24.03-lts-sp1/Dockerfile) | Milvus 2.5.6 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/pymilvus` image from docker

	```bash
	docker pull openeuler/pymilvus:{Tag}
	```

- Example: Connect to Milvus Lite

    ```
    from pymilvus import MilvusClient

    client = MilvusClient(uri="./milvus_demo.db")
    ```
    After running the code above, a new file called `milvus_demo.db` will be generated in your current working directory.

- Notes
    * The same API works for Milvus Lite, Milvus Standalone, Milvus Distributed, and Zilliz Cloud.
    * The only difference is  the `uri`:
      * For Milvus Lite, use a local file path, e.g. `./milvus_demo.db`
      * For Milvus Standalone for Milvus Distributed, use the server endpoint and your token, e.g.:
        ```
        client = MilvusClient(
            uri="http://localhost:19530",
            token="username:password"
        )
        ```
      * The local `.db` file is portable, You can copy it to another location to persist or back up your data.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).