# Quick reference

- The official OpenLB docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# OpenLB | openEuler
The OpenLB project is a C++ package for the implementation of lattice Boltzmann methods adressing a vast range of tansport problems.


# Supported tags and respective Dockerfile links
The tag of each `openlb` docker image is consist of the version of `openlb` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.7.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/openlb/1.7.0/24.03-lts/Dockerfile)| OpenLB 1.7.0 on openEuler 24.03-LTS | amd64, arm64 |
|[1.8.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/openlb/1.8.0/24.03-lts-sp1/Dockerfile)| OpenLB 1.8.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/openlb` image from docker

	```bash
	docker pull openeuler/openlb:{Tag}
	```

- Start a openlb instance

	```bash
	docker run -it --rm openeuler/openlb:{Tag}
	```

- Running Test Cases

	All test cases can be compiled by running the make samples command. For details about how to execute an independent test case, for example, cylinder2d, see Non-parallel Computing and Parallel Computing.

	- Non-parallel Computing Procedure
		1. Go to the directory where the test case is stored.
			```bash
			cd examples/laminar/cylinder2d
			```
		2. Compile the test case.
			```bash
			make
			```
		3. Run the program to perform the computing.
			```bash
			./cylinder2d
			```
			The generated VTK and gnuplot results are stored in the /tmp directory.

	- Parallel Computing Procedure
		1. Go to the directory where the test case is stored.
			```bash
			cd examples/laminar/cylinder2d
			```
		2. Compile the test case.
			```bash
			make
			```
		3. Run the program to perform the computing. The following uses -np=64 and OMP_NUM_THREADS=1 as an example.
			```bash
			mpirun –allow-run-as-root –np 64 –x OMP_NUM_THREADS=1 ./cylinder2d
			```
			The generated VTK and gnuplot results are stored in the /tmp directory.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).