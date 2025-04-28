# Quick reference

- The official OpenFOAM docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# OpenFOAM | openEuler
Current OpenFOAM container images are built on [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

OpenFOAM is the free, open source CFD software developed primarily by OpenCFD Ltd since 2004. It has a large user base across most areas of engineering and science, from both commercial and academic organisations. OpenFOAM has an extensive range of features to solve anything from complex fluid flows involving chemical reactions, turbulence and heat transfer, to acoustics, solid mechanics and electromagnetics.

Learn more on [OpenFOAM Web Site](https://www.openfoam.com/).

# Supported tags and respective Dockerfile links
The tag of each `openfoam` docker image is consist of the version of OpenFOAM and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[2412-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/openfoam/2412/24.03-lts-sp1/Dockerfile)| OpenFOAM 2412 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
Here, you can select the corresponding `{Tag}` by their requirements.

- Pull the `openeuler/openfoam` image from docker
	```
	docker pull openeuler/openfoam:{Tag}
	```
- Run and test a `openfoam` container
	```
	docker run -it --rm openeuler/openfoam:{Tag}
	```
	This will enter the path like this:
	```
    /opt/OpenFOAM-v{VERSION}
	```
	where `VERSION` is decided by `Tag`.

	Here, you can run the following command to test the container
	```
	cd tutorials/incompressible/pisoFoam/LES/motorBike/motorBike
	./Allrun
	```
	It finishes successfully as follows:
	```
	[root@7ae3c3cbfedf motorBike]# ./Allrun
	Running blockMesh on /opt/OpenFOAM-v2412/tutorials/incompressible/pisoFoam/LES/motorBike/motorBike
	Running decomposePar on /opt/OpenFOAM-v2412/tutorials/incompressible/pisoFoam/LES/motorBike/motorBike
	Running snappyHexMesh (8 processes) on /opt/OpenFOAM-v2412/tutorials/incompressible/pisoFoam/LES/motorBike/motorBike
	Restore 0/ from 0.orig/  [processor dirs]
	Running renumberMesh (8 processes) on /opt/OpenFOAM-v2412/tutorials/incompressible/pisoFoam/LES/motorBike/motorBike
	Running potentialFoam (8 processes) on /opt/OpenFOAM-v2412/tutorials/incompressible/pisoFoam/LES/motorBike/motorBike
	Running checkMesh (8 processes) on /opt/OpenFOAM-v2412/tutorials/incompressible/pisoFoam/LES/motorBike/motorBike
	Running simpleFoam (8 processes) on /opt/OpenFOAM-v2412/tutorials/incompressible/pisoFoam/LES/motorBike/motorBike
	```
	Once the test is finished, you can check `ExecutionTime` in `log.simpleFoam` which represents the performance.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).