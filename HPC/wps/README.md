# Quick reference

- The official WPS docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# WPS | openEuler

Current WPS docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

The WRF Pre-Processing System (WPS) is a collection of Fortran and C programs that provides data used as input to the real.exe program. There are three main programs and a number of auxiliary programs that are part of WPS.

- geogrid

	1. Defines the model horizontal domain
	2. Horizontally interpolates static data to the model domain
	3. Output conforms to the WRF I/O API

- ungrib

	1. Decodes Grib Edition 1 and 2 data
	2. Uses tables to decide which variables to extract
	3. Supports isobaric and generalized vertical coordinates
	4. Output is in a non-WRF-I/O-API form, referred to as an intermediate format

- metgrid

	1. Ingests static data and raw meteorological fields
	2. Horizontally interpolates meteorological fields to the model domain
	3. Output conforms to the WRF I/O API

Learn more on [WRF Model Users Site](https://www2.mmm.ucar.edu/wrf/users/).

# Supported tags and respective Dockerfile links

The tag of each `wps` docker image is consist of the version of `wps` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
| [4.7.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/wps/4.7.0/24.03-lts-sp4/Dockerfile) | WPS 4.7.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

Here, users can select the corresponding `{Tag}` by requirements.

- Pull the `openeuler/wps` image from docker

	```bash
	docker pull openeuler/wps:{Tag}
	```

- Start an interactive WPS instance

	```bash
	docker run -it --name my-wps openeuler/wps:{Tag}
	```

	This will give you a bash prompt in the WPS directory, and from here you can begin your work to run the WPS tasks.

- Check the logs of the running container

	```bash
	docker logs -f my-wps
	```

- Execute a command in the running container

	```bash
	docker exec -it my-wps geogrid.exe
	```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
