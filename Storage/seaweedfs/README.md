# Quick reference

- The official seaweedfs docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# seaweedfs | openEuler
Current seaweedfs docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

SeaweedFS is a fast distributed storage system for blobs, objects, files, and data lake, for billions of files! Blob store has O(1) disk seek, cloud tiering.

# Supported tags and respective Dockerfile links
The tag of each `seaweedfs` docker image is consist of the version of `seaweedfs` and the version of basic image. The details are as follows

| Tag                                                                                                                               | Currently                                 | Architectures |
|-----------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|---------------|
|[3.97-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/seaweedfs/3.97/24.03-lts-sp1/Dockerfile) | seaweedfs 3.97 on openEuler 24.03-LTS-SP1 | amd64, arm64 |
| [3.85-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/seaweedfs/3.85/24.03-lts-sp1/Dockerfile) | seaweedfs 3.85 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/seaweedfs` image from docker

	```bash
	docker pull openeuler/seaweedfs:{Tag}
	```

- Start a seaweedfs instance

    ```
    docker run -it --rm openeuler/seaweedfs:{Tag}
    ```
    The `openeuler/seaweedfs` image is used to verify the integration between the upstream seaweedfs version and openEuler. 

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).