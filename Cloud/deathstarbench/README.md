# Quick reference

- The official DeathStarBench docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# DeathStarBench | openEuler
Current DeathStarBench images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

DeathStarBench is an open-source benchmark suite for cloud microservices. It provides a set of end-to-end microservice applications for evaluating microservice frameworks, cloud operating systems, cluster managers, and hardware systems. The suite includes applications such as a hotel reservation system, social network, and media microservices.

Read more on [DeathStarBench GitHub](https://github.com/delimitrou/DeathStarBench).

# Supported tags and respective dockerfile links
The tag of each `deathstarbench` docker image is consist of the version of `deathstarbench` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
|[0.4.1-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Cloud/deathstarbench/0.4.1/24.03-lts-sp3/Dockerfile) | DeathStarBench 0.4.1 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/deathstarbench` image from docker

	```
	docker pull openeuler/deathstarbench:{Tag}
	```

- Start a deathstarbench instance

    ```
    docker run -it --rm openeuler/deathstarbench:{Tag}
    ```
    The `openeuler/deathstarbench` image builds the hotelReservation microservice benchmark and installs all service binaries (frontend, geo, profile, rate, recommendation, reservation, search, user, etc.).

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
