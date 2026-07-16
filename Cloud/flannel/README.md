# Quick reference

- The official flannel docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# flannel | openEuler
Current flannel images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Flannel is a simple and easy way to configure a layer 3 network fabric designed for Kubernetes. It runs a small, single binary agent called `flanneld` on each host, and is responsible for allocating a subnet lease to each host out of a large, preconfigured address space. Packets are forwarded using one of several backend mechanisms such as VXLAN and various cloud integrations.

# Supported tags and respective dockerfile links
The tag of each `flannel` docker image is consist of the version of `flannel` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
| [0.28.7-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Cloud/flannel/0.28.7/24.03-lts-sp3/Dockerfile) | flannel 0.28.7 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
| [0.27.3-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Cloud/flannel/0.27.3/24.03-lts-sp4/Dockerfile) | flannel 0.27.3 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
| [0.27.3-oe2403sp1](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Cloud/flannel/0.27.3/24.03-lts-sp1/Dockerfile) | flannel 0.27.3 on openEuler 24.03-LTS-SP1 | amd64, arm64 |
| [0.26.7-oe2403sp1](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Cloud/flannel/0.26.7/24.03-lts-sp1/Dockerfile) | flannel 0.26.7 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/flannel` image from docker

	```
	docker pull openeuler/flannel:{Tag}
	```

- Start a flannel instance

	```
	docker run -d --name my-flannel --cap-add NET_ADMIN --net=host openeuler/flannel:{Tag} --ip-masq --kube-subnet-mgr
	```

- Container startup options

	| Option | Description |
	|--------|-------------|
	| `--ip-masq` | Enable IP masquerading for traffic destined outside the overlay. |
	| `--iface` | The network interface to use for inter-host communication. |
	| `--kube-subnet-mgr` | Use the Kubernetes API as the backing store instead of etcd. |
	| `--etcd-endpoints` | Comma-separated list of etcd endpoints when not using Kubernetes API. |
	| `--subnet-file` | Path to write the subnet env file (default `/run/flannel/subnet.env`). |
	| `--cap-add NET_ADMIN` | Required to manage network interfaces and routes. |
	| `--net=host` | Run in the host network namespace so flannel can program host routes. |

- View container running logs

	```
	docker logs -f my-flannel
	```

- To get an interactive shell

	```
	docker exec -it my-flannel /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
