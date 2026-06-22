# Quick reference

- The official KubeRay docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# KubeRay | openEuler
Current KubeRay images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

KubeRay is an open-source Kubernetes operator for managing Ray clusters. It simplifies the deployment, scaling, and lifecycle management of distributed Ray applications on Kubernetes by providing custom resources such as RayCluster, RayJob, and RayService. KubeRay is well-suited for distributed machine learning, data processing, and high-performance computing workloads. This image includes the core `kuberay-operator` and `kuberay-apiserver` components.

Read more on [KubeRay Website](https://ray-project.github.io/kuberay/).

# Supported tags and respective dockerfile links
The tag of each `kuberay` docker image is consist of the version of `kuberay` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
| [1.6.2-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/kuberay/1.6.2/24.03-lts-sp3/Dockerfile) | KubeRay 1.6.2 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/kuberay` image from docker

	```
	docker pull openeuler/kuberay:{Tag}
	```

- Start the kuberay-operator

    ```
    docker run -it --rm openeuler/kuberay:{Tag} kuberay-operator
    ```

- Start the kuberay-apiserver

    ```
    docker run -it --rm openeuler/kuberay:{Tag} kuberay-apiserver
    ```

- Run with an interactive shell

    ```
    docker run -it --rm openeuler/kuberay:{Tag} bash
    ```
    The `openeuler/kuberay` image is used to verify the integration between the upstream KubeRay version and openEuler.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
