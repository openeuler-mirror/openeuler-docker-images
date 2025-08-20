# Quick reference

- The official cp2k container image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# cp2k | openEuler
Current cp2k container images are built on [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

CP2K is a quantum chemistry and solid state physics software package that can perform atomistic simulations of solid state, liquid, molecular, periodic, material, crystal, and biological systems. CP2K provides a general framework for different modeling methods such as DFT using the mixed Gaussian and plane waves approaches GPW and GAPW. Supported theory levels include DFT, MP2, RPA, GW, tight-binding (xTB, DFTB), semi-empirical methods (AM1, PM3, PM6, RM1, MNDO, ...), and classical force fields (AMBER, CHARMM, ...). CP2K can do simulations of molecular dynamics, metadynamics, Monte Carlo, Ehrenfest dynamics, vibrational analysis, core level spectroscopy, energy minimization, and transition state optimization using NEB or dimer method.

Learn more on [cp2k website](https://www.cp2k.org/).


# Supported tags and respective Dockerfile links
Each tag of cp2k container image consists of the version of CP2K and the version of base image. The details are as follows

| Tags | Currently |  Architectures|
|------|-----------|---------------|
|[2024.3-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/cp2k/2024.3/24.03-lts/Dockerfile)| CP2K 2024.3 on openEuler 24.03-LTS | amd64, arm64 |
|[2025.2-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/cp2k/2025.2/24.03-lts-sp2/Dockerfile)| CP2K 2025.2 on openEuler 24.03-LTS-SP2 | amd64, arm64 |


# Usage
Here, users can select the `{Tag}` and container startup options by their requirements.

- Pull the `openeuler/cp2k` image from `hub.docker.com`
	```bash
	docker pull openeuler/cp2k:{Tag}
	```
- Run CP2K 
	The CP2K container can be invoked with docker like this:
	```bash
	docker run openeuler/cp2k:{Tag} cp2k --version
	```
	The following example runs a [benchmark](https://github.com/cp2k/cp2k/tree/master/benchmarks/QS)⁠ with 32 water molecules using 2 OpenMP threads and 3 MPI ranks:
	```
	mkdir playground
	cd playground
	wget https://raw.githubusercontent.com/cp2k/cp2k/master/benchmarks/QS/H2O-32.inp
	docker run -v $PWD:/mnt --shm-size=1g -e OMP_NUM_THREADS=2 -it --rm openeuler/cp2k:{Tag} mpiexec -np 3 cp2k H2O-32.inp
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).