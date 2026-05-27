# Quick reference

- The official MILC docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# MILC | openEuler
Current MILC docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

The MILC Code is a body of high performance research software written in C (with some C++) for doing SU(3) lattice gauge theory on high performance computers as well as single-processor workstations. A wide variety of applications are included, such as the RHMC algorithm for HISQ fermions (su3_rhmd_hisq).

Learn more on [MILC QCD](https://github.com/milc-qcd/milc_qcd).

# Supported tags and respective Dockerfile links
The tag of each `milc` docker image is consist of the version of `milc` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.0.0-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/milc/1.0.0/24.03-lts-sp3/Dockerfile) | MILC 1.0.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
Here, users can select the corresponding `{Tag}` by their requirements.

- Pull the `openeuler/milc` image from docker

	```
	docker pull openeuler/milc:{Tag}
	```

- Start a `milc` instance

	```
	docker run -it --rm openeuler/milc:{Tag}
	```

- Run MILC program (example with su3_rhmd_hisq using 4 MPI processes)

	```bash
	cd /opt/milc_qcd/build/ks_imp_rhmc
	mpirun --allow-run-as-root -np 4 ./su3_rhmd_hisq
	```

	Note: MILC programs require input parameter files. Users need to prepare appropriate input files for their specific physics problems.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).