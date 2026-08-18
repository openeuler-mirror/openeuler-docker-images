# Quick reference

- The official NCO docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# NCO | openEuler
The netCDF Operators (NCO) comprise about a dozen standalone, command-line programs that take [netCDF](http://www.unidata.ucar.edu/netcdf), [HDF](http://hdfgroup.org), and/or [DAP](http://opendap.org) files as input, then operate (e.g., derive new fields, compute statistics, print, hyperslab, manipulate metadata, regrid) and output the results to screen or files in text, binary, or netCDF formats. NCO aids analysis of gridded and unstructured scientific data. The shell-command style of NCO allows users to manipulate and analyze files interactively, or with expressive scripts that avoid some overhead of higher-level programming environments.
Learn more at [NCO Homepage](http://nco.sf.net).

# Supported tags and respective Dockerfile links
The tag of each NCO docker image is consist of the version of NCO and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[5.4.0-alpha04-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/nco/5.4.0-alpha04/24.03-lts-sp4/Dockerfile) | NCO 5.4.0-alpha04 on openEuler 24.03-lts-sp4 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Pull the NCO docker image from DockerHub:
```
	docker pull openeuler/nco:{Tag}
```
- Print the metadata of a netCDF file, e.g., `in.nc`, located in the current working directory:
```
	docker run --rm -v $(pwd):/data openeuler/nco:{Tag} ncks -m in.nc
```
- Copy the variable `lat` from `in.nc` to `out.nc`:
```
	docker run --rm -v $(pwd):/data openeuler/nco:{Tag} ncks -v lat -O in.nc out.nc
```
- NCO operators are command-line programs that exit after the operation completes, so the container stops as soon as the operator finishes; results are printed to the terminal or written to output files rather than to container logs.
```
	docker run --rm -v $(pwd):/data openeuler/nco:{Tag} ncra -O in.nc avg.nc
```
- To run multiple NCO operators interactively, start a shell inside the container and execute the operators one by one:
```
	docker run -it --rm -v $(pwd):/data openeuler/nco:{Tag} /bin/bash
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
