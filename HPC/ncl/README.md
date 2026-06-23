# Quick reference

- The official ncl docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# ncl | openEuler
NCL (NCAR Command Language) is a scripting language for the analysis and visualization of climate and weather data.

- Supports NetCDF, GRIB, HDF, HDF-EOS, and shapefile data formats
- Has hundreds of built-in computational routines
- Produces high-quality graphics

NCL is developed by the Computational and Information Systems Lab at the National Center for Atmospheric Research (NCAR).


# Supported tags and respective Dockerfile links
The tag of each ncl docker image is consist of the version of ncl and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[6.6.2-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/ncl/6.6.2/24.03-lts-sp3/Dockerfile) | ncl 6.6.2 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
This image provides NCAR Graphics and associated utilities for climate and weather data processing.

List available tools:

```
docker run -it --rm openeuler/ncl:{Tag} ls /usr/local/ncarg/bin/
```

Convert GRIB to netCDF:

```
docker run -it --rm -v $(pwd):/data -w /data openeuler/ncl:{Tag} ncl_convert2nc input.grb
```

View NCAR Graphics examples:

```
docker run -it --rm openeuler/ncl:{Tag} ng4ex gsun01n
```

Learn more on [NCL website](http://www.ncl.ucar.edu).

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).