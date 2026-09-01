# Quick reference

- The official miniGhost docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# miniGhost | openEuler
Current miniGhost docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

MiniGhost is a 3D halo-exchange mini-application from the Mantevo suite. It represents 3D nearest neighbor halo-exchange communications present in many HPC codes, implementing difference stencils with boundary exchange in a Bulk Synchronous Parallel (BSP) model.

Learn more on [miniGhost](https://github.com/Mantevo/miniGhost).

# Supported tags and respective Dockerfile links
The tag of each `miniGhost` docker image consists of the version of `miniGhost` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.0.0-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/minighost/1.0.0/24.03-lts-sp3/Dockerfile) | miniGhost 1.0.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
|[1.0.0-oe2403sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/minighost/1.0.0/24.03-lts-sp4/Dockerfile) | miniGhost 1.0.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
Here, users can select the corresponding `{Tag}` by their requirements.

- Pull the `openeuler/minighost` image from docker

	```bash
	docker pull openeuler/minighost:{Tag}
	```

- Run and test `miniGhost` container

	```bash
	docker run -it --rm openeuler/minighost:{Tag}
	```
	From here, users can test miniGhost with MPI as follows
	```bash
	mpirun -np 4 ./miniGhost.x
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
