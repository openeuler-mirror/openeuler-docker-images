# Quick reference

- The official JuiceFS docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# JuiceFS | openEuler
Current JuiceFS docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

JuiceFS is a high-performance distributed file system designed for the cloud. It is built on top of object storage (Amazon S3, Google Cloud Storage, Azure Blob Storage, MinIO, Ceph, etc.) and various metadata engines (Redis, TiKV, PostgreSQL, MySQL, etc.), providing a POSIX-compatible interface. JuiceFS decouples data and metadata storage, enabling elastic scaling, low cost, and strong consistency for cloud-native workloads.

Learn more about JuiceFS on [JuiceFS Website](https://juicefs.com)⁠.

# Supported tags and respective Dockerfile links
The tag of each `juicefs` docker image is consist of the version of `juicefs` and the version of basic image. The details are as follows

| Tag                                                                                                                                   | Currently                                    | Architectures |
|---------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------|---------------|
|[1.3.1-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Storage/juicefs/1.3.1/24.03-lts-sp4/Dockerfile) | JuiceFS 1.3.1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[1.3.1-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Storage/juicefs/1.3.1/24.03-lts-sp3/Dockerfile) | JuiceFS 1.3.1 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/juicefs` image from docker

	```bash
	docker pull openeuler/juicefs:{Tag}
	```

- Format a new volume (using Redis as metadata engine and MinIO as object storage)

    ```bash
    docker run --rm openeuler/juicefs:{Tag} \
        juicefs format \
        --storage minio \
        --bucket http://minio:9000/mybucket \
        --access-key minioadmin \
        --secret-key minioadmin \
        redis://redis:6379/1 \
        myvol
    ```

- Mount the volume

    ```bash
    docker run --rm --privileged \
        -v /mnt/juicefs:/mnt/jfs:shared \
        openeuler/juicefs:{Tag} \
        juicefs mount redis://redis:6379/1 /mnt/jfs
    ```

- Check version

    ```bash
    docker run --rm openeuler/juicefs:{Tag} juicefs --version
    ```

- View all available commands

    ```bash
    docker run --rm openeuler/juicefs:{Tag} juicefs --help
    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
