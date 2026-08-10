# Quick reference

- The official qp2 docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# qp2 | openEuler
Current qp2 docker images are built on [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

qp2 (Quantum Package 2) is an open-source programming environment for quantum chemistry specially designed for wave function methods. Its main goal is the development of determinant-driven selected configuration interaction (sCI) methods and multi-reference second-order perturbation theory (PT2).

Learn more on [qp2 website](https://quantumpackage.github.io/qp2).

# Supported tags and respective Dockerfile links
The tag of each `qp2` docker image consists of the version of qp2 and the version of basic image. The details are as follows

| Tags | Currently | Architectures |
|------|-----------|---------------|
|[2.1.2-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/qp2/2.1.2/24.03-lts-sp3/Dockerfile)| qp2 2.1.2 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
|[2.1.2-oe2403sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/qp2/2.1.2/24.03-lts-sp4/Dockerfile)| qp2 2.1.2 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
Here, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/qp2` image from docker

	```bash
	docker pull openeuler/qp2:{Tag}
	```

- Run qp2 container

	```bash
	docker run -it --rm openeuler/qp2:{Tag}
	```

- Create an EZFIO database and run a calculation

	```bash
	docker run -it --rm -v $PWD:/data openeuler/qp2:{Tag} qp_create -o h2o h2o.xyz
	docker run -it --rm -v $PWD:/data openeuler/qp2:{Tag} qp_run scf h2o
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
