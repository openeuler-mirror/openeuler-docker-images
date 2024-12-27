# Quick reference

- The official cesm docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# CESM | openEuler
Current cesm docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

The Community Earth System Model(CESM) is a fully coupled global climate model developed in collaboration with colleagues in the research community. CESM provides state of the art computer simulations of Earth's past, present, and future climate states.

Learn more on [cesm website](https://www.cesm.ucar.edu/).


# Supported tags and respective Dockerfile links
The tag of each cesm docker image is consist of the version of cesm and the version of basic image. The details are as follows

| Tags | Currently |  Architectures|
|------|-----------|---------------|
|[2.2.2-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/cesm/2.2.2/24.03-lts/Dockerfile)| CESM 2.2.2 on openEuler 24.03-LTS | amd64, arm64 |


# Usage
Here, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/cesm` image from `hub.docker.com`

	```bash
	docker pull openeuler/cesm:{Tag}
	```

- Start a `cesm` instance

	```bash
	docker run -it --name my-cesm openeuler/cesm:{Tag}
	```
	This will give you a bash prompt like this:
	```
	[root@cesm ncar]$
    ```
	From here, you can follow the standard CESM documentation on creating/building/submitting cases.
	In this case, the submission runs in the foreground. An example set of commands to build a 2-degree F2000climo (scientifically 			unsupported, just used as an example) case, with a case name / directory of 'mycase' follows:
	```
	create_newcase --case mycase --compset F2000climo --res f19_g17 --run-unsupported
	cd mycase
	./xmlchange NTASKS=4
	./case.setup
	./case.build
	```
	It finishes successfully as follows:
	```
	Time spent building: 289.431136 sec
	MODEL BUILD HAS FINISHED SUCCESSFULLY
	```
	This will require about 7-10GB of RAM for 1-4 tasks - if you haven't configured your Docker environment to allow that, you'll need to change that under Docker's settings.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).