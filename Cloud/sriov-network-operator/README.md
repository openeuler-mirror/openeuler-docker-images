# Quick reference

- The official SR-IOV Network Operator docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# SR-IOV Network Operator | openEuler
Current SR-IOV Network Operator images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

SR-IOV Network Operator is an open-source Kubernetes Operator that automates the provisioning and management of SR-IOV (Single Root I/O Virtualization) network devices in Kubernetes clusters. It enables high-performance network pass-through for Network Function Virtualization (NFV) workloads. This image includes four core components: `sriov-network-operator` (main controller), `sriov-network-config-daemon` (per-node configuration daemon), `sriov-network-webhook` (admission control webhook), and `sriov-network-operator-config-cleanup` (configuration cleanup tool).

Read more on [SR-IOV Network Operator Website](https://github.com/k8snetworkplumbingwg/sriov-network-operator).

# Supported tags and respective dockerfile links
The tag of each `sriov-network-operator` docker image is consist of the version of `sriov-network-operator` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
| [1.6.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Cloud/sriov-network-operator/1.6.0/24.03-lts-sp3/Dockerfile) | SR-IOV Network Operator 1.6.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/sriov-network-operator` image from docker

	```
	docker pull openeuler/sriov-network-operator:{Tag}
	```

- Start the sriov-network-operator controller

    ```
    docker run -it --rm openeuler/sriov-network-operator:{Tag} sriov-network-operator
    ```

- Start the sriov-network-config-daemon

    ```
    docker run -it --rm --privileged openeuler/sriov-network-operator:{Tag} sriov-network-config-daemon
    ```

- Start the sriov-network-webhook

    ```
    docker run -it --rm openeuler/sriov-network-operator:{Tag} sriov-network-webhook
    ```

- Run with an interactive shell

    ```
    docker run -it --rm openeuler/sriov-network-operator:{Tag} bash
    ```
    The `openeuler/sriov-network-operator` image is used to verify the integration between the upstream SR-IOV Network Operator version and openEuler.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
