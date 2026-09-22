# Quick reference

- The official moose docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# moose | openEuler
Current moose docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

moose provides MOOSE (Multiphysics Object Oriented Simulation Environment), an open-source, parallel finite element framework for solving coupled multiphysics systems. Built on top of libMesh, PETSc and SLEPc, the image ships the framework libraries and headers (for building MOOSE-based applications) together with the `moose_test` application, `exodiff` and `hit` tools.

Learn more on [MOOSE framework](https://mooseframework.inl.gov/).

# Supported tags and respective Dockerfile links
The tag of each `moose` docker image is consist of the version of `moose` and the version of basic image. The details are as follows

| Tag                                                                                                                        | Currently                             | Architectures |
|----------------------------------------------------------------------------------------------------------------------------|---------------------------------------|---------------|
|[2025.09.05-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/moose/2025.09.05/24.03-lts-sp4/Dockerfile) | moose 2025.09.05 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
| [4.1.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/moose/4.1.0/24.03-lts-sp4/Dockerfile) | moose 4.1.0 on openEuler 24.03-LTS-SP4 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/moose` image from docker

	```bash
	docker pull openeuler/moose:{Tag}
	```

- Start a moose container and run a MOOSE input file

	```bash
	docker run -it --name my-moose -v $(pwd):/workspace -w /workspace openeuler/moose:{Tag} bash
	```

	Write the following `diffusion.i`:

	```
	[Mesh]
	  type = GeneratedMesh
	  dim = 1
	  nx = 5
	[]

	[Variables]
	  [u]
	  []
	[]

	[Kernels]
	  [diff]
	    type = Diffusion
	    variable = u
	  []
	[]

	[BCs]
	  [left]
	    type = DirichletBC
	    variable = u
	    boundary = left
	    value = 0
	  []
	  [right]
	    type = DirichletBC
	    variable = u
	    boundary = right
	    value = 1
	  []
	[]

	[Executioner]
	  type = Steady
	[]

	[Outputs]
	  console = true
	  exodus = false
	[]
	```

	Run the input file inside the container:

	```bash
	moose_test-opt -i diffusion.i
	```

- Build a MOOSE-based application against the installed framework

	```bash
	mpicxx -c my_app.C $(libmesh-config --include) -I/usr/include/moose
	```

- View container running logs

	```bash
	docker logs -f my-moose
	```

- To get an interactive shell

	```bash
	docker exec -it my-moose /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
