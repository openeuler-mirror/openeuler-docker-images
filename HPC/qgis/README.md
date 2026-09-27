# Quick reference

- The official QGIS container image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# QGIS | openEuler
Current QGIS docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

QGIS is a free, open source, cross-platform geographic information system (GIS) that supports viewing, editing, analysing and publishing geospatial information. It ships with a large set of native and third-party data providers (GDAL/OGR, GEOS, PROJ, PostGIS, SpatiaLite, WMS/WMTS/WFS and more).

Learn more on [QGIS website](https://qgis.org/).


# Supported tags and respective Dockerfile links
The tag of each QGIS container image is consist of the version of QGIS and the version of basic image. The details are as follows

| Tags | Currently |  Architectures|
|------|-----------|---------------|
|[4.2.2-oe2403sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/qgis/4.2.2/24.03-lts-sp4/Dockerfile)| QGIS 4.2.2 on openEuler 24.03-LTS-SP4 | amd64, arm64 |


# Usage
- Pull the `openeuler/qgis` image from `hub.docker.com`
	```
	docker pull openeuler/qgis:{Tag}
	```
- Start a `qgis` instance
	```
	docker run -it --name my-qgis openeuler/qgis:{Tag}
	```
	Now, you can use QGIS inside the container. The desktop application needs an X display (or a headless Qt platform such as `offscreen`):
	```
	# The desktop executable
	qgis --version

	# The processing/CLI executable
	qgis_process --version
	```
	**Note:** This image is built without the Python bindings (PyQt6/SIP are not packaged on openEuler), so Python plugins and the Python console are not available. The core C++ application, its GDAL/GEOS/PROJ providers, SpatiaLite, 3D and QtWebEngine support are included.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
