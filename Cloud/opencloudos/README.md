# Quick reference

- The official OpenCloudOS (nettrace) docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# OpenCloudOS | openEuler
Current OpenCloudOS images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

OpenCloudOS is an open-source Linux operating system community initiative led by Tencent and other companies. This image packages **nettrace**, the flagship eBPF-based network diagnostic tool from OpenCloudOS. nettrace provides network packet tracing, fault diagnosis, and anomaly monitoring capabilities for Linux cloud-native environments.

Read more on [OpenCloudOS GitHub](https://github.com/orgs/OpenCloudOS/repositories) and [nettrace](https://github.com/OpenCloudOS/nettrace).

# Supported tags and respective dockerfile links
The tag of each `opencloudos` docker image is consist of the version of `opencloudos` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
|[1.2.11-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Cloud/opencloudos/1.2.11/24.03-lts-sp3/Dockerfile) | OpenCloudOS nettrace 1.2.11 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/opencloudos` image from docker

	```
	docker pull openeuler/opencloudos:{Tag}
	```

- Run nettrace to trace network packets (requires privileged mode and host network)

    ```
    docker run --rm --privileged --network host \
        -v /lib/modules:/lib/modules:ro \
        openeuler/opencloudos:{Tag} \
        nettrace -p icmp
    ```

- Diagnose network drop events

    ```
    docker run --rm --privileged --network host \
        -v /lib/modules:/lib/modules:ro \
        openeuler/opencloudos:{Tag} \
        nettrace --drop
    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
