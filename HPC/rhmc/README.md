# Quick reference

- The official RHMC (SIMULATeQCD) docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# RHMC | openEuler
Current RHMC docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

SIMULATeQCD is a C++ lattice QCD software package based on NVIDIA CUDA (and partially AMD HIP) for high-performance computing. It provides tools for generating gauge configurations and performing measurements in lattice QCD simulations.

Learn more on [SIMULATeQCD GitHub](https://github.com/LatticeQCD/SIMULATeQCD).

# Supported tags and respective Dockerfile links
The tag of each `rhmc` docker image is consist of the version of `rhmc` and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.2.0-oe2403sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/rhmc/1.2.0/24.03-lts-sp4/Dockerfile) | SIMULATeQCD 1.2.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/rhmc` image from docker

	```bash
	docker pull openeuler/rhmc:{Tag}
	```

- Run a container with GPU support (requires NVIDIA Container Toolkit)

	```bash
	docker run --gpus all -it --rm openeuler/rhmc:{Tag}
	```

- View container running logs

	```bash
	docker logs -f my-rhmc
	```

- To get an interactive shell

	```bash
	docker exec -it my-rhmc /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).