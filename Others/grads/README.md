# Quick reference

- The official GrADS docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# GrADS | openEuler
The Grid Analysis and Display System (GrADS) is a tool for fast and easy access, manipulation, analysis, and visualization of Earth science data. GrADS has two data models for handling both gridded and station data, and supports all of the standard data file formats. GrADS uses a 5-Dimensional data environment: the four conventional dimensions (longitude, latitude, vertical level, and time) plus an optional fifth dimension for grids that is generally implemented but designed to be used for ensembles. Analysis operations are executed via algebraic expressions, which are evaluated recursively so that expressions may be nested. A rich set of built-in functions are provided, but users may also add their own functions as external plug-ins that may be written in any programming language. GrADS has a programmable interface (scripting language) that allows for sophisticated analysis and display applications. GrADS can be run interactively or in batch mode.


# Supported tags and respective Dockerfile links
The tag of each GrADS docker image is consist of the version of GrADS and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[2.2.3-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/grads/2.2.3/24.03-lts-sp3/Dockerfile) | GrADS 2.2.3 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
To start GrADS interactively:

```
docker run -it openeuler/grads:{Tag}
```

To run a GrADS script in batch mode:

```
docker run --rm -v $(pwd):/data openeuler/grads:{Tag} grads -blc "run /data/script.gs"
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
