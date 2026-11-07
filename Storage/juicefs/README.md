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
|[1.4.2-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Storage/juicefs/1.4.2/24.03-lts-sp4/Dockerfile) | juicefs 1.4.2 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[1.4.1-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Storage/juicefs/1.4.1/24.03-lts-sp4/Dockerfile) | juicefs 1.4.1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[1.3.1-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Storage/juicefs/1.3.1/24.03-lts-sp4/Dockerfile) | JuiceFS 1.3.1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[1.3.1-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Storage/juicefs/1.3.1/24.03-lts-sp3/Dockerfile) | JuiceFS 1.3.1 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/juicefs` image from docker

	```bash
	docker pull openeuler/juicefs:{Tag}
	```

- Prepare the metadata engine and object storage

    The `juicefs format` example below uses Redis as the metadata engine and MinIO as the object storage. These services are not included in the JuiceFS image, so they must be deployed and reachable from the JuiceFS container before formatting a volume.

    > **Note**
    > - `redis:6379` and `minio:9000` in the examples are container names. They are resolvable only when all containers are attached to the same user-defined Docker network; the default `bridge` network does not provide DNS resolution for container names. Replace them with the actual IP addresses or DNS names if the services are deployed elsewhere.
    > - The MinIO bucket (`mybucket` in the examples) must exist before running `juicefs format`.
    > - The access key and secret key must match the credentials of the MinIO service.

    For a quick local trial, the following commands start Redis and MinIO on a dedicated network and create the bucket:

    ```bash
    docker network create juicefs-net

    docker run -d --name redis --network juicefs-net redis:7

    docker run -d --name minio --network juicefs-net \
        -e MINIO_ROOT_USER=minioadmin \
        -e MINIO_ROOT_PASSWORD=minioadmin \
        -v /data/minio:/data \
        minio/minio server /data

    docker run --rm --network juicefs-net \
        -e MC_HOST_local=http://minioadmin:minioadmin@minio:9000 \
        minio/mc mb -p local/mybucket
    ```

- Format a new volume (using Redis as metadata engine and MinIO as object storage)

    ```bash
    docker run --rm --network juicefs-net openeuler/juicefs:{Tag} \
        juicefs format \
        --storage minio \
        --bucket http://minio:9000/mybucket \
        --access-key minioadmin \
        --secret-key minioadmin \
        redis://redis:6379/1 \
        myvol
    ```

    If Redis and MinIO are already deployed elsewhere, remove `--network juicefs-net` and use their addresses in `--bucket` and the metadata URL.

- Mount the volume

    ```bash
    mkdir -p /mnt/juicefs

    docker run --rm --privileged --network juicefs-net \
        -v /mnt/juicefs:/mnt/jfs:shared \
        openeuler/juicefs:{Tag} \
        juicefs mount redis://redis:6379/1 /mnt/jfs
    ```

    The mount command requires FUSE access, which is why `--privileged` is used here. It runs in the foreground; add `-d` if you want to run it in the background.

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