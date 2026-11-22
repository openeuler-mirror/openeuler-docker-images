# Quick reference

- The official rdma-core docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# rdma-core | openEuler
Current rdma-core docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

RDMA Core Userspace Libraries and Daemons. This is the userspace components for the Linux Kernel's drivers/infiniband subsystem. Specifically this contains the userspace libraries for the following device nodes:

- /dev/infiniband/uverbsX (libibverbs)
- /dev/infiniband/rdma_cm (librdmacm)
- /dev/infiniband/umadX (libibumad)

The userspace component of the libibverbs RDMA kernel drivers are included under the providers/ directory. Additional service daemons are provided for srp_daemon (ib_srp.ko), iwpmd (for iwarp kernel providers) and ibacm (for InfiniBand communication management assistant).

Learn more about rdma-core on [rdma-core GitHub repository](https://github.com/linux-rdma/rdma-core).

# Supported tags and respective Dockerfile links
The tag of each `rdma-core` docker image is consist of the version of `rdma-core` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
| [66.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Cloud/rdma-core/66.0/24.03-lts-sp4/Dockerfile) | rdma-core 66.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/rdma-core` image from docker

	```bash
	docker pull openeuler/rdma-core:{Tag}
	```

- Print the usage of `ibv_devinfo`

	```bash
	docker run --rm openeuler/rdma-core:{Tag}
	```

- List the RDMA devices available on the host

	```bash
	docker run --rm --privileged openeuler/rdma-core:{Tag} ibv_devices
	```

- Print detailed information about the RDMA devices

	```bash
	docker run --rm --privileged openeuler/rdma-core:{Tag} ibv_devinfo -v
	```

- Start a long-running container for exploration

	```bash
	docker run -d --name my-rdma-core openeuler/rdma-core:{Tag} sleep infinity
	```

- View the container logs

	```bash
	docker logs -f my-rdma-core
	```

- To get an interactive shell

	```bash
	docker exec -it my-rdma-core bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
