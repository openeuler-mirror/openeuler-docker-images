# Quick reference

- The official kubectl docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# Kubectl | openEuler
Current test-pkg images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

kubectl is the command-line tool used to run commands against Kubernetes clusters. It communicates with the Kubernetes API server to create, inspect, update, and delete cluster resources such as Pods, Deployments, and Services. This image ships the official prebuilt kubectl binary on top of an openEuler base image, providing a ready-to-run CLI for operating Kubernetes clusters on both x86 (amd64) and ARM (arm64) hosts.

# Supported tags and respective dockerfile links
The tag of each `test-pkg` docker image is consist of the version of `kubectl` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
| [1.36.2-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Cloud/test-pkg/1.36.2/24.03-lts-sp3/Dockerfile) | Kubectl 1.36.2 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/test-pkg` image from docker

	```
	docker pull openeuler/test-pkg:{Tag}
	```

- Run a kubectl command against a cluster

	```
	docker run --rm openeuler/test-pkg:{Tag} get nodes
	```

- Point kubectl at a cluster with a kubeconfig file

	```
	docker run --rm -v ~/.kube:/root/.kube openeuler/test-pkg:{Tag} cluster-info
	```

- Check the kubectl version

	```
	docker run --rm openeuler/test-pkg:{Tag} version --client
	```

- Container startup options

	| Option | Description |
	|--------|-------------|
	| `--rm` | Automatically remove the container after the command exits. |
	| `-v ~/.kube:/root/.kube` | Mount the local kubeconfig directory into the container. |
	| `-v <path>:/tmp/manifests` | Mount a directory of manifest files to apply with `kubectl apply -f`. |
	| `--network=host` | Use the host network so kubectl can reach an in-cluster API server. |

- To get an interactive shell

	```
	docker run --rm -it --entrypoint /bin/bash openeuler/test-pkg:{Tag}
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
