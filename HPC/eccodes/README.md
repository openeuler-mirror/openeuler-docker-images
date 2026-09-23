# Quick reference

- The official ecCodes docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).
# ecCodes | openEuler
ecCodes is a package developed by ECMWF which provides an application programming interface
and a set of tools for decoding and encoding messages in the following formats:

   * WMO FM-92 GRIB edition 1 and edition 2
   * WMO FM-94 BUFR edition 3 and edition 4
   * WMO GTS abbreviated header (only decoding)

A useful set of command line tools provide quick access to the messages.
C, Fortran 90 and Python interfaces provide access to the main ecCodes functionality.

ecCodes is an evolution of GRIB API.
It is designed to provide the user with a simple set of functions to access data from
several formats with a key/value approach.

Learn more on [ecCodes Home - ecCodes - ECMWF Confluence Wiki](https://confluence.ecmwf.int/display/ECC/ecCodes+Home).

# Supported tags and respective Dockerfile links
The tag of each ecCodes docker image is consist of the version of ecCodes and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[2.48.3-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/eccodes/2.48.3/24.03-lts-sp4/Dockerfile) | ecCodes 2.48.3 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
To pull the ecCodes image:

	```
	docker pull openeuler/eccodes:{Tag}
	```

To run the ecCodes container and use the command-line tools:

	```
	docker run --rm openeuler/eccodes:{Tag} grib_ls -h
	```

To inspect a GRIB file mounted into the container:

	```
	docker run --rm -v /path/to/data:/data openeuler/eccodes:{Tag} grib_ls /data/sample.grib
	```

To inspect the ecCodes installation inside the container:

	```
	docker run --rm openeuler/eccodes:{Tag} codes_info
	```

Inspect the logs of a running ecCodes container:

	```
	docker logs <container-name>
	```

Execute a command inside a running ecCodes container:

	```
	docker exec -it <container-name> bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
