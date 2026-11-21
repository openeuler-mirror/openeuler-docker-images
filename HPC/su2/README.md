# Quick reference

- The official SU2 docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# SU2 | openEuler
SU2 is a suite of open-source software tools written in C++ for the numerical solution of partial differential equations (PDE) and performing PDE constrained optimization.

The primary applications are computational fluid dynamics and aerodynamic shape optimization, but has been extended to treat more general equations such as electrodynamics and chemically reacting flows.

Learn more on [SU2 | Multiphysics Simulation and Design Software](https://su2code.github.io).

# Supported tags and respective Dockerfile links
The tag of each `su2` docker image is consist of the version of `su2` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
|[8.6.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/su2/8.6.0/24.03-lts-sp4/Dockerfile)| SU2 8.6.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/su2` image from docker

	```bash
	docker pull openeuler/su2:{Tag}
	```

- Start a container to check the SU2 version

	```bash
	docker run --rm openeuler/su2:{Tag} SU2_CFD --help
	```

- Run an SU2 simulation

	SU2 reads its input from a configuration file (`.cfg`). Mount the working directory containing the configuration file and the mesh, then run the solver:

	```bash
	docker run --rm -v $PWD:/workspace -w /workspace openeuler/su2:{Tag} SU2_CFD inv_channel.cfg
	```

- Run in parallel with MPI

	```bash
	docker run --rm -v $PWD:/workspace -w /workspace openeuler/su2:{Tag} mpirun -np 4 SU2_CFD inv_channel.cfg
	```

	Where `4` is the number of MPI processes to be used.

- View the logs of a running container

	```bash
	docker logs <container>
	```

- Open an interactive shell inside a running container

	```bash
	docker exec -it <container> bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).