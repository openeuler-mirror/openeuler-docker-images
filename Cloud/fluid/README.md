# Quick reference

- The official Fluid docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Fluid | openEuler
Current Fluid images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Fluid is an open-source Kubernetes-native distributed dataset orchestrator and accelerator for data-intensive applications such as big data and AI workloads. It is a CNCF incubating project that provides elastic data abstraction and acceleration by bridging the gap between storage systems and compute frameworks. Fluid enables unified dataset management, automated data caching, and data affinity scheduling across native, edge, serverless, and multi-cluster Kubernetes environments.

Read more on [Fluid Website](https://fluid-cloudnative.github.io/).

# Supported tags and respective dockerfile links
The tag of each `fluid` docker image is consist of the version of `fluid` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
| [1.0.8-oe2403sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/fluid/1.0.8/24.03-lts-sp4/Dockerfile) | Fluid 1.0.8 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
| [1.0.8-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/fluid/1.0.8/24.03-lts-sp3/Dockerfile) | Fluid 1.0.8 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/fluid` image from docker

	```
	docker pull openeuler/fluid:{Tag}
	```

- Start the dataset-controller

    ```
    docker run -it --rm openeuler/fluid:{Tag} dataset-controller start
    ```

- Start the fluid-webhook

    ```
    docker run -it --rm openeuler/fluid:{Tag} fluid-webhook
    ```

- Start the fluid-csi driver

    ```
    docker run -it --rm --privileged openeuler/fluid:{Tag} fluid-csi
    ```

- Run with an interactive shell

    ```
    docker run -it --rm openeuler/fluid:{Tag} bash
    ```
    The `openeuler/fluid` image is used to verify the integration between the upstream Fluid version and openEuler.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
