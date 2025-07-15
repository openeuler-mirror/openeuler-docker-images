# Quick reference

- The official Istio docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Istio | openEuler
Current Istio images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Istio is an open source service mesh that layers transparently onto existing distributed applications. Istio’s powerful features provide a uniform and more efficient way to secure, connect, and monitor services. Istio is the path to load balancing, service-to-service authentication, and monitoring – with few or no service code changes.

Read more on [Istio Docs](https://istio.io/latest/docs/).

# Supported tags and respective dockerfile links
The tag of each `istio` docker image is consist of the version of `istio` and the version of basic image. The details are as follows

| Tag                                                                                                                             | Currently                               | Architectures |
|---------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------|---------------|
| [1.25.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/istio/1.25.1/24.03-lts-sp1/Dockerfile) | Istio 1.25.1 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/istio` image from docker

	```
	docker pull openeuler/istio:{Tag}
	```

- Start a istio instance

    ```
    docker run -it --rm openeuler/istio:{Tag}
    ```
    The `openeuler/istio` image is used to verify the integration between the upstream Istio version and openEuler. 

  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).