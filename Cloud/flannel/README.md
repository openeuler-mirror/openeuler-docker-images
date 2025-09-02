# Quick reference

- The official flannel docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# flannel | openEuler
Current flannel images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Flannel is a simple and easy way to configure a layer 3 network fabric designed for Kubernetes.

# Supported tags and respective dockerfile links
The tag of each `flannel` docker image is consist of the version of `flannel` and the version of basic image. The details are as follows

| Tag                                                                                                                               | Currently                                 | Architectures |
|-----------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|---------------|
|[0.27.3-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/flannel/0.27.3/24.03-lts-sp1/Dockerfile) | flannel 0.27.3 on openEuler 24.03-LTS-SP1 | amd64, arm64 |
| [0.26.7-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/flannel/0.26.7/24.03-lts-sp1/Dockerfile) | flannel 0.26.7 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/flannel` image from docker

	```
	docker pull openeuler/flannel:{Tag}
	```

- Start a flannel instance

    ```
    docker run -it --rm openeuler/flannel:{Tag}
    ```
    The `openeuler/flannel` image is used to verify the integration between the upstream flannel version and openEuler. 

  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).