# Quick reference

- The official Reed-Solomon docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# Reed-Solomon | openEuler
Current Reed-Solomon docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Reed-Solomon is a high-performance erasure coding library in pure Go, implementing Reed-Solomon error correction. It provides forward error correction, allowing recovery of data from a subset of shards even when some are lost or corrupted. It is widely used in distributed storage systems to achieve data durability without full replication.

Learn more about Reed-Solomon on [GitHub](https://github.com/klauspost/reedsolomon)⁠.

# Supported tags and respective Dockerfile links
The tag of each `reedsolomon` docker image is consist of the version of `reedsolomon` and the version of basic image. The details are as follows

| Tag                                                                                                                                          | Currently                                           | Architectures |
|----------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------|---------------|
|[1.14.1-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Storage/reedsolomon/1.14.1/24.03-lts-sp4/Dockerfile) | Reed-Solomon 1.14.1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[1.14.1-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Storage/reedsolomon/1.14.1/24.03-lts-sp3/Dockerfile) | Reed-Solomon 1.14.1 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/reedsolomon` image from docker

	```bash
	docker pull openeuler/reedsolomon:{Tag}
	```

- Encode a file into shards

    ```bash
    docker run --rm -v $(pwd):/data openeuler/reedsolomon:{Tag} \
        simple-encoder -data 4 -par 2 /data/myfile.dat
    ```

    This splits `myfile.dat` into 4 data shards and 2 parity shards, producing files `myfile.dat.0` through `myfile.dat.5`.

- Decode shards back into the original file

    ```bash
    docker run --rm -v $(pwd):/data openeuler/reedsolomon:{Tag} \
        simple-decoder -data 4 -par 2 /data/myfile.dat
    ```

- Stream encode a file

    ```bash
    docker run --rm -v $(pwd):/data openeuler/reedsolomon:{Tag} \
        stream-encoder -data 4 -par 2 /data/myfile.dat
    ```

- Available tools

    | Tool             | Description                                |
    |------------------|--------------------------------------------|
    | `simple-encoder` | Encode a file into N data + M parity shards |
    | `simple-decoder` | Reconstruct original file from shards       |
    | `stream-encoder` | Stream-based shard encoder                  |
    | `stream-decoder` | Stream-based shard decoder                  |

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
