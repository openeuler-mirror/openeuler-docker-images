# Quick reference

- The official CPMD container image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# CPMD | openEuler

Current CPMD container images are built on [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

CPMD is a parallelized plane wave / pseudopotential implementation of Density Functional Theory, particularly designed for ab-initio molecular dynamics. CPMD provides capabilities for performing first-principles quantum mechanical calculations, including molecular dynamics simulations, geometry optimizations, vibrational analysis, and electronic structure calculations.

Learn more on [CPMD website](https://www.cpmd.org/).


# Supported tags and respective Dockerfile links

Each tag of CPMD container image consists of the version of CPMD and the version of base image. The details are as follows

| Tags | Currently |  Architectures|
|------|-----------|---------------|
|[4.3-oe2403sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/cpmd/4.3/24.03-lts-sp4/Dockerfile)| CPMD 4.3 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[4.3-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/cpmd/4.3/24.03-lts-sp3/Dockerfile)| CPMD 4.3 on openEuler 24.03-LTS-SP3 | amd64, arm64 |


# Usage

Here, users can select the `{Tag}` and container startup options by their requirements.

- Pull the `openeuler/cpmd` image from `hub.docker.com`
	```bash
	docker pull openeuler/cpmd:{Tag}
	```
- Run CPMD 
	The CPMD container can be invoked with docker like this:
	```bash
	docker run openeuler/cpmd:{Tag} cpmd.x --version
	```
	The following example runs a CPMD calculation with MPI:
	```
	mkdir playground
	cd playground
	wget https://www.cpmd.org/htdocs/examples/example1.tar.gz
	tar xzf example1.tar.gz
	docker run -v $PWD:/mnt --shm-size=1g -e OMP_NUM_THREADS=2 -it --rm openeuler/cpmd:{Tag} mpiexec -np 4 cpmd.x input.inp > output.out
	```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
