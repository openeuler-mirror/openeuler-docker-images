# Quick reference

- The official PyRosetta docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# PyRosetta | openEuler
Current PyRosetta docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

PyRosetta is a Python-based interactive platform for the computational design and modeling of proteins, built on the Rosetta biomolecular modeling suite. It provides access to molecular modeling algorithms for structure prediction, design, and analysis.

Learn more on [PyRosetta official site](https://www.pyrosetta.org/).

# Supported tags and respective Dockerfile links
The tag of each `pyrosetta` docker image is consist of the version of `pyrosetta` and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[2026.29-oe2403sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/pyrosetta/2026.29/24.03-lts-sp4/Dockerfile) | PyRosetta 2026.29 on openEuler 24.03-LTS-SP4 | amd64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/pyrosetta` image from docker

	```bash
	docker pull openeuler/pyrosetta:{Tag}
	```

- Run a container and start an interactive Python session

	```bash
	docker run -it --rm openeuler/pyrosetta:{Tag}
	```

- Import PyRosetta inside the container

	```bash
	docker run -it --rm openeuler/pyrosetta:{Tag} python3 -c "import pyrosetta; print(pyrosetta.version())"
	```

	The `openeuler/pyrosetta` image is used to verify the integration between the upstream PyRosetta version and openEuler.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).