# Quick reference

- The official Calico docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Calico | openEuler
Current Calico images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Calico is a single platform for networking, network security, and observability for any Kubernetes distribution in the cloud, on-premises, or at the edge. Whether you're just starting with Kubernetes or operating at scale, Calico's open source, enterprise, and cloud editions provide the networking, security, and observability you need.

Read more on [Calico Website](https://docs.tigera.io/calico/latest/about/).

# Supported tags and respective dockerfile links
The tag of each `calico` docker image is consist of the version of `calico` and the version of basic image. The details are as follows

| Tag                                                                                                                              | Currently                                | Architectures |
|----------------------------------------------------------------------------------------------------------------------------------|------------------------------------------|---------------|
| [3.29.3-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/calico/3.29.3/24.03-lts-sp1/Dockerfile) | Calico 3.29.3 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/calico` image from docker

	```
	docker pull openeuler/calico:{Tag}
	```

- Start a calico instance

    ```
    docker run -it --rm openeuler/calico:{Tag}
    ```
    The `openeuler/calico` image is used to verify the integration between the upstream calico version and openEuler. 

  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).