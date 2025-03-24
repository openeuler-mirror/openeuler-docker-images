# Quick reference

- The official SWAN docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# SWAN | openEuler
Current SWAN docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

SWAN is a third-generation wave model, developed at Delft University of Technology, that computes random, short-crested wind-generated waves in coastal regions and inland waters. 

Learn more on [SWAN](https://swanmodel.sourceforge.io/).

# Supported tags and respective Dockerfile links
The tag of each `SWAN` docker image is consist of the version of `SWAN` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[41.51-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/swan/41.51/24.03-lts/Dockerfile)| SWAN 41.51 on openEuler 24.03-LTS | amd64, arm64 |


# Usage
Here, users can select the corresponding `{Tag}` by their requirements.

- Pull the `openeuler/swan` image from docker

	```
	docker pull openeuler/swan:{Tag}
	```

- Start a SWAN instance

	```
	docker run -it --rm openeuler/swan:{Tag}
	```
	From here, users can run their tasks.

- Run Test Cases

	1. Download test cases
	```
	mkdir swan-testcse
	cd swan-testcse
	wget http://swanmodel.sourceforge.net/download/zip/refrac.tar.gz --no-check-certif icate
	tar -zxvf refrac.tar.gz
	```
	2. Run a test case
	```
	cd refrac
	ln -s $workdir/swan.exe ./
	cp a11refr.swn INPUT
	mpirun -np 8 ./swan.exe
	```
	It finishes successfully as follows:
	```
	 SWAN is preparing computation

	 iteration    1; sweep 1
	+iteration    1; sweep 2
	+iteration    1; sweep 3
	+iteration    1; sweep 4
	 not possible to compute, first iteration

	 iteration    2; sweep 1
	+iteration    2; sweep 2
	+iteration    2; sweep 3
	+iteration    2; sweep 4
	 accuracy OK in 100.00 % of wet grid points ( 99.50 % required)

	+SWAN is processing output request    1
	+SWAN is processing output request    2
	+SWAN is processing output request    3
	+SWAN is processing output request    4
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).